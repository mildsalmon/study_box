from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from airflow.hooks.postgres_hook import PostgresHook

from datetime import datetime
from datetime import timedelta

import requests
import logging


def get_Redshift_connection():
    """
    Airflow Web Admin의 Connections를 통해 redshift 연결

    # Airflow Connections을 통해 만들어진 Redshift connection은 autocommit값이 False가 default
    """
    hook = PostgresHook(postgres_conn_id='redshift_dev_db')
    return hook.get_conn().cursor()


def extract(**context) -> dict:
    """
    Weather forecast api를 통해 ETL처리하고자 하는 내용을 추출

    :param context:
        :keys 'params': api 접근 uri
    :return: json 객체
    """
    url = context['params']['url']

    f = requests.get(url)
    f_json = f.json()

    return f_json


def transform(**context) -> list:
    """
    api를 통해 얻은 내용 중에서 원하는 내용(date, day temp, max temp, min temp)만 읽어서 원하는 포멧으로 변환

    :return: 앞으로 7일간의 온도 정보
    """
    days = context['task_instance'].xcom_pull(key='return_value', task_ids='extract')['daily']

    extract_days = []

    for day in days:
        date = datetime.fromtimestamp(day['dt']).strftime('%Y-%m-%d')
        day_temp = day['temp']['day']
        max_temp = day['temp']['max']
        min_temp = day['temp']['min']

        extract_days.append([date, day_temp, min_temp, max_temp])

    logging.info(extract_days)

    return extract_days


def load(**context):
    """
    1. weather_forecast table과 동일한 속성, default 값을 갖는 임시 테이블(temp_weather_forecast)을 생성.
    2. weather_forecast table의 ROWS를 temp_weather_forecast table에 복사 (CTAS)
    --- 트랜잭션 BEGIN
    3. temp_weather_forecast table에 api를 통해 새로 수집한 정보를 INSERT
    4. weather_forecast table의 ROWS를 전부 삭제
    5. temp_weather_forecast table에서 date 컬럼을 기준으로 PK를 보장하는 방법으로 weather_forecast table에 INSERT (CTAS)
        1) date 컬럼을 기준으로 PARTITION BY를 실행하고 create_date 컬럼을 기준으로 내림차순 정렬하여 첫번째 값만 선택하여 PK를 보장한다.
    --- 트랜잭션 END

    :param context:
        :keys 'params':
            :keys 'schema': redshift의 schema 이름
            :keys 'table': redshift의 table 이름
            :keys 'temp_table': incremental update에 사용될 임시 table
    :return:
    """
    schema = context['params']['schema']
    table = context['params']['table']
    temp_table = context['params']['temp_table']
    days = context['task_instance'].xcom_pull(key='return_value', task_ids='transform')

    cur = get_Redshift_connection()

    # 임시 테이블에 원래 테이블의 정보를 저장
    sql = f"DROP TABLE IF EXISTS {schema}.{temp_table};"
    sql += f"""CREATE TABLE {schema}.{temp_table} (like {schema}.{table} INCLUDING DEFAULTS);"""
    sql += f"""
            INSERT INTO {schema}.{temp_table}
            SELECT date, temp, min_temp, max_temp, create_date
            FROM {schema}.{table}
            ;
            """
    logging.info(sql)
    cur.execute(sql)

    # 임시 테이블에 새로운 정보를 트랜잭션으로 삽입
    sql = "BEGIN;"
    for day in days:
        logging.info(f"date: {day[0]}, day: {day[1]}, min: {day[2]}, max: {day[3]}")
        sql += f"INSERT INTO {schema}.{temp_table} VALUES ('{day[0]}', '{day[1]}', '{day[2]}', '{day[3]}');"

    # 원래 테이블 내용 삭제
    # DROP -> ALTER는 트랜잭션으로 불가능해서 DELETE한 다음 table에 INSERT함
    sql += f"DELETE FROM {schema}.{table};"
    sql += f"""
            INSERT INTO {schema}.{table} (
                SELECT date, temp, min_temp, max_temp, create_date
                FROM (
                    SELECT date, temp, min_temp, max_temp, create_date
                         , ROW_NUMBER() OVER (PARTITION BY date ORDER BY create_date DESC) AS rank
                    FROM {schema}.{temp_table}
                )
                WHERE rank = 1
            )
            ;
            """
    sql += "END;"

    logging.info(sql)

    cur.execute(sql)


# DAG
weather_forecast_incremental_update = DAG(
    dag_id='weather_forecast_incremental_update',
    start_date=datetime(2022, 3, 6),
    schedule_interval='0 2 * * *',
    catchup=False,
    default_args={
        'retries': 1,
        'retry_delay': timedelta(minutes=3),
    }
)


# tasks
# 위도 / 경도
lat = 37.5642135
lon = 127.0016985

extract = PythonOperator(
    task_id='extract',
    python_callable=extract,
    params={
        'url': f"https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&appid={Variable.get('weather_api_key')}&units=metric"
    },
    provide_context=True,
    dag=weather_forecast_incremental_update
)

transform = PythonOperator(
    task_id='transform',
    python_callable=transform,
    params={
    },
    provide_context=True,
    dag=weather_forecast_incremental_update
)

load = PythonOperator(
    task_id='load',
    python_callable=load,
    params={
        'schema': 'mildsalmon_su',
        'table': 'weather_forecast',
        'temp_table': 'temp_weather_forecast'
    },
    provide_context=True,
    dag=weather_forecast_incremental_update
)

# task 실행 순서
extract >> transform >> load
