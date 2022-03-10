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
    Full refresh 방식으로 데이터를 red shift에 적재.

    :param context:
        :keys 'params':
            :keys 'schema': redshift의 schema 이름
            :keys 'table': redshift의 table 이름
    :return:
    """
    schema = context['params']['schema']
    table = context['params']['table']
    days = context['task_instance'].xcom_pull(key='return_value', task_ids='transform')

    cur = get_Redshift_connection()

    sql = f"BEGIN;DELETE FROM {schema}.{table};"

    for day in days:
        print(f"date: {day[0]}, day: {day[1]}, min: {day[2]}, max: {day[3]}")
        sql += f"INSERT INTO {schema}.{table} VALUES ('{day[0]}', '{day[1]}', '{day[2]}', '{day[3]}');"
    sql += "END;"

    logging.info(sql)

    cur.execute(sql)


# DAG
weather_forecast = DAG(
    dag_id='weather_forecast',
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
    dag=weather_forecast
)

transform = PythonOperator(
    task_id='transform',
    python_callable=transform,
    params={
    },
    provide_context=True,
    dag=weather_forecast
)

load = PythonOperator(
    task_id='load',
    python_callable=load,
    params={
        'schema': 'mildsalmon_su',
        'table': 'weather_forecast'
    },
    provide_context=True,
    dag=weather_forecast
)

# task 실행 순서
extract >> transform >> load
