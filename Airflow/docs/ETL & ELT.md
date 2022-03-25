# Table of Contents

- [1. ETL (Extract, Transform, Load) = 데이터 파이프라인, DAG,](#1-etl-extract-transform-load--데이터-파이프라인-dag)
    - [A. 데이터 파이프라인](#a-데이터-파이프라인)
        - [a. 협의의 데이터 파이프라인](#a-협의의-데이터-파이프라인)
        - [b. 광의의 데이터 파이프라인](#b-광의의-데이터-파이프라인)
        - [c. 데이터 파이프라인을 만들 때 고려할 점](#c-데이터-파이프라인을-만들-때-고려할-점)
            - [ㄱ) Best Practices](#ㄱ-best-practices)
                - [1) 데이터를 읽어올 때](#1-데이터를-읽어올-때)
                    - [가) Incremental Update를 해야하는 경우](#가-incremental-update를-해야하는-경우)
                    - [나) Incremental Update를 피해야하는 이유](#나-incremental-update를-피해야하는-이유)
                    - [다) Incremental Update가 가능한 경우](#다-incremental-update가-가능한-경우)
                    - [라) Incremental Update가 불가능한 경우](#라-incremental-update가-불가능한-경우)
                - [2) 멱등성(Idempotency)](#2-멱등성idempotency)
                - [3) [[backfill]]](#3-backfill)
                - [4) 문서화](#4-문서화)
                - [5) 데이터 파이프라인 사고시 사고 리포트 작성](#5-데이터-파이프라인-사고시-사고-리포트-작성)
    - [B. 간단한 ETL](#b-간단한-etl)
        - [a. Extract](#a-extract)
        - [b. Transform](#b-transform)
        - [c. Load](#c-load)
- [2. ELT](#2-elt)

---

# 1. ETL (Extract, Transform, Load) = 데이터 파이프라인, DAG,  

> Data Source에서 Data를 Extract(읽어서, 추출해서)하고 우리가 원하는 format으로 Transform(변환)한 다음에 Data Warehouse에 Load(적재)하는 것

- **하나의 데이터 파이프라인** 안에 **여러개의 Task**들이 있을 수 있음
	- Task들이 그래프처럼 방향성을 가지고 Task가 끝나면 다음 Task가 실행되는 방식처럼 Task들의 실행 순서를 Graph처럼 표현할 수 있다.
- Data Source들이 DW에 없고 외부에 있는 것
	- 외부에 있는 데이터를 읽어서 DW에 적재하는 것

## A. 데이터 파이프라인

- 데이터를 소스로부터 목적지로 복사하는 작업
	- 코딩(파이썬, 스칼라) 혹은 SQL을 통해 이뤄짐
	- 대부분의 경우 목적지는 DW가 됨

### a. 협의의 데이터 파이프라인

- ETL
- **외부 Data를 읽어서 DW에 적재**하는 것

### b. 광의의 데이터 파이프라인

- Summary Table 만드는 것처럼 source가 DW 자체가 되고 목적지도 DW가 된다.
- **source가 DW이고 목적지가 production database나 외부 시스템**이 될 수도 있다.

### c. 데이터 파이프라인을 만들 때 고려할 점

- 데이터 파이프라인은 많은 이유로 실패함
	- 버그
	- **데이터 소스상의 이유**
	- **데이터 파이프라인들 간의 의존도**에 대한 이해도 부족
- 데이터 파이프라인의 수가 늘어나면 유지보수 비용이 기하급수적으로 늘어남
	- 데이터 소스간의 의존도가 생기면서 이는 더 복잡해짐

---

- 실패할 것을 고려하고 동작시켜야 한다.
	- **정말 중요한 파이프라인이 무엇**이고, 그 파이프라인들이 어떻게 동작하고, **소스에 문제가 생겼을 때는 어떻게 대응**할 것인지에 대한 부분이 잘 준비되어야 함.

#### ㄱ) Best Practices

##### 1) 데이터를 읽어올 때

- Full Refresh
	- 매번 **통째로 복사**해서 테이블을 만들기
	- 데이터가 작을 경우에 적용.
- Incremental Update
	- 데이터 소스가 **특정 날짜를 기준으로 새로 생성되거나 업데이트**된 레코드들을 읽어와서 갱신
	- Production Database 테이블이라면 아래 필드가 있어야지 Incremental Update가 가능함
		- created (timestamp)
			- Optional
		- modified (timestamp)
			- record가 수정될 가능성이 전혀 없는 경우에는 modified timestamp가 필요 없음
		- deleted (boolean)
			- 레코드를 삭제하지 않고 delete를 True로 설정
			- record를 physical하게 삭제하면, Incremental update를 할 수 없음
			- 개인정보와 같은 보안 이슈가 있지 않는 한, table을 physical하게 delete하는 것은 좋지 않음.

	###### 가) Incremental Update를 해야하는 경우
	
	- 데이터가 너무 커서 매번 통째로 읽어올 수 없는 경우
	- 돈을 내고 부르는 API인데 API 호출 비용이 비싼 경우
	
	###### 나) Incremental Update를 피해야하는 이유
	
	- 복잡도를 증가시키기 때문
	
	###### 다) Incremental Update가 가능한 경우
	
	- 데이터 소스가 몇가지 기능을 지원해줘야 함.
		- 특정 날짜 이후로 변경/삭제된 record를 가져오는 query를 할 수 있어야 함.
		- 특정 시간 / 특정 아이디 이후에 생기거나 변경된 record들만 가져오는 query를 할 수 있어야 함.
	
	###### 라) Incremental Update가 불가능한 경우
	
	- data source가 위 기능을 제공하지 않으면 Incremental Update를 할 방법이 없다.
	
##### 2) 멱등성(Idempotency)

- 멱등성
	- 동일한 입력 데이터로 데이터 파이프라인을 다수 실행해도 최종 테이블의 내용이 달라지지 않아야 함

---

- 동일한 입력이 있는 경우(입력 source가 바뀌지 않았을 떄), 데이터 파이프라인을 몇 번 돌리던 DW에 있는 데이터는 동일해야한다.

##### 3) [backfill](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/backfill.md)

##### 4) 문서화

- 데이터 파이프라인의 입력과 출력을 명확히 하고 문서화해야 함
	- 데이터 디스커버리 문제
- **주기적(quarter에 한 번)으로 쓸모없는 데이터들(dag)을 삭제**

##### 5) 데이터 파이프라인 사고시 사고 리포트 작성

- 데이터 파이프라인 사고시마다 사고 리포트(post-mortem)쓰기
	- 목적은 동일한 혹은 아주 비슷한 사고가 또 발생하는 것을 막기 위함
- 중요 데이터 파이프라인의 **입력과 출력의 테스트 케이스를 만들어서 체크**하기
	- 아주 간단하게 **입력 레코드 수와 출력 레코드 수가 몇개인지** 체크하는 것부터 시작
	- summary table을 만들어내고 primary key가 존재한다면 **primary key uniqueness가 보장되는지** 체크.
	- **중복 레코드 체크**

## B. 간단한 ETL

### a. Extract

> 데이터를 **데이터 소스에서 읽어내는** 과정

```python

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

```

### b. Transform

> 필요하다면 그 **원본 데이터의 포멧을 원하는 형태로 변경**시키는 과정

```python

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

```

### c. Load

> 최종적으로 **Data Warehouse에 테이블로 집어넣는** 과정

```python

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

```

# 2. ELT

> 이미 Data Warehouse에 raw data table들이 모여 있고 **raw data table로부터 우리가 원하는 정보들을 뽑아서 새로운 테이블을 만들**어냄

- Summary Table을 만드는 과정
- Extract 대상이 대부분 이미 우리 안에 들어와 있는 데이터임.
	- Source가 DW일 수도 있고 DL이 될수도 있음
	- 이미 우리 시스템(DW, DL)에 있는 데이터를 summary해서 원하는 정보를 만들어가지고 다시 DW에 적재하거나 Data Mart에 저장함.
- DBT를 사용하기도 함
	- DBT는 CTAS를 통해서 주기적으로 요약된 테이블을 만들어주는 것을 다양한 방법으로 제공하는 툴
- ELT를 할 때는 SQL뿐만 아니라 Spark처럼 범용적인 대용량 프레임워크를 사용하기도 함.