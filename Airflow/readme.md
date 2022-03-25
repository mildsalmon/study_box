# 1. 사전 지식

> Airflow 안에서 job들이 ETL 또는 ELT 형태로 동작한다.

[ETL & ELT](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/ETL%20%26%20ELT.md)

# 2. Airflow 소개

## A. 소개

- Airflow는 Python으로 만들어진 **data pipeline을 위한 플랫폼**
- **스케줄링 지원**
	- 단순히 스케줄러가 아니라 데이터 파이프라인의 작성을 쉽게 해주는 프레임워크이기도 함.
	- Web UI가 제공됨
- DAG를 만드는데 다양한 도움을 주는 프레임워크

### a. cluster

> Airflow 자체도 cluster임

- DAG의 수가 늘어나고 DAG를 자주 실행해야 한다면 Airflow 한대로는 버거워서 server를 추가해주는데, 그러다보면 관리하는게 쉽지 않음
	- cluster로 돌아가는 것은 관리하기가 쉽지 않음
	- 돈이 있으면 cloud에 있는 것을 사용하는 것이 제일 좋음
		- google cloud compose, AWS MWAA
	- 다양한 내부 정보들을 DB에 저장해야함.
		- DAG들의 종류, 실행 시점, 과거 실행 기록 등 다양한 configuration 정보들
		- default 내부 DB로 SQLite를 사용함
			- SQLite는 싱글 스레드 데이터베이스이자 파일 기반 데이터베이스라 production 또는 개발 용도로 사용하지 못함

## B. [DAG](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/DAG.md)(directed acyclic graph)

## C. [Operator](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/Operator.md)

## C. 컴포넌트

> 총 5개의 컴포넌트로 구성

1. Web Server
	- Python Flask
2. Scheduler
	- cronjob
3. Worker
	- DAG를 실행해주는 worker
4. Database
	- SQLite가 기본으로 설치됨
5. Queue
	- 멀티노드 구성인 경우에만 사용됨
		- 멀티노드로 구성하게 되면 복잡도가 확 늘어서 cloud를 고려하는게 좋음
		- 서버가 다수 생긴다는 의미는 server failure가 발생할 확률이 늘어난다는 의미
	- 이 경우 Executor가 달라짐.
		- CeleryExecuter, KubernetesExecutor

## D. 아키텍쳐

### a. Single Node Airflow (Node 하나짜리 Airflow)

![](/bin/DE7_image/DE7_7_3.png)

- **노드 하나에 Webserver, Scheduler, Worker**가 있음
- 이 정보들이 meta store라는 관계형 데이터베이스에 저장됨
- 노드 1개일때도 queue가 있는데, queue라고 할 수도 없는 정도의 간단한 IPC(Inter-Processor Communication)을 queue 형태로 사용한다.

#### ㄱ) Scale Up

> 리소스가 부족해지면, 더 좋은 사양의 서버를 사용한다.

DAG가 증가하면 server의 사양을 올린다.

### b. Multi Node Airflow

![](/bin/DE7_image/DE7_7_4.png)

- **Webserver와 Scheduler는 master node**에 있고 **Worker의 수만 늘어난**다.
- worker가 master node와 같은 곳에 있는게 아니라 별개의 server로 존재한다.
- scheduler가 task를 schedule할 때, 바로바로 worker한테 나눠주지 않고 queue에 넣으면 worker들이 읽어가는 형태로 바뀐다.

#### ㄱ) Scale Out

> scale 문제가 생기면 server를 늘려서 scaling 문제를 해결한다.

- scale ability가 더 좋긴 하지만 유지보수 복잡도가 올라간다.

## E. Airflow의 장/단점

### a. Airflow의 장점

> 코드 하나를 가지고 backfill도 하고 오늘부터 미래의 데이터를 읽어오는데 쓸 수 있다.
> > 이렇게 동작하려면 airflow에서 원하는 형태로 코드를 작성해야 한다.

- Airflow 프레임워크가 데이터 파이프라인을 만드는데 최적화된 것이기 떄문에 다양한 형태로 실행 순서를 정의할 수 있다.
- 다양한 operator들을 통해 개발이 쉽다.
- [backfill](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/backfill.md)을 쉽게 할 수 있다.

### b. Airflow의 단점

- 용어가 헷갈릴 수 있다.
- deploy나 test에 대해 잘 확립된 프로세스들이 있지는 않음
- multi node로 가는 순간 유지보수가 어려워진다.

## F. Command Line

ssh로 airflow 서버에 로그인하고 airflow 사용자로 변경

- `airflow dags list`
- `airflow tasks list [DAG 이름]`
- `airflow tasks test [DAG 이름] [task 이름] [execution date]`
	- execution date
		- 날짜는 `YYYY-MM-DD`
			- start_date보다 과거인 경우는 실행이 되지만 오늘 날짜보다 미래인 경우 실행 안됨
- `airflow tasks list`
- `airflow tasks test [DAG 이름] [task 이름] [execution date]`
- `airflow tasks run [DAG 이름] [task 이름] [execution date]`
- `airflow dags test [DAG 이름] [execution date]`
- `airflow dags backfill [DAG 이름] -s [start date] -e [end date]`

## G. Variables and Connections

### a. Variable

```python

from airflow.models import Variable

extract = PythonOperator(
	task_id = 'extract',
	python_callable = extract,
	params = {
		'url': Variable.get("csv_url")
	},
	provide_context=True,
	dag = dag_second_assignment
)

```

- Variable.get([key])
	- task에서 url을 하드코딩하지 않고 airflow의 Variable에서 읽어오도록 함
- Variable.set([key])
	- Variable의 값을 갱신함.

![](/bin/DE7_image/DE7_8_6.png)

- Variable은 Web UI에서 설정가능한데, Encryption이 가능함.
	- Encryption Keyword = [access_token, api_key, apikey, authorization, passphrase, passwd, password, private_key, secret, token]

### b. Connections

외부 데이터베이스 등의 로그인이 필요한 시스템들을 연결할 때의 정보들을 적어줌

```python

from airflow.hooks.postgres_hook import PostgresHook

def get_Redshift_connection():
	hook = PostgresHook(postgres_conn_id='redshift_dev_db')
	return hook.get_conn().cursor()

```

### c. Xcom 객체

Xcom Object를 사용하여 앞에 실행된 task에서 특정 값들을 읽어올 수 있음

```python

def transform(**context):
    text = context["task_instance"].xcom_pull(key="return_value", task_ids="extract")
    lines = text.split("\n")[1:]
    return lines

```

- xcom_pull(key='', 'task_ids='')
	- task_ids에 해당하는 task에서 key(return한 값)를 가져와라.

## H. airflow 버전

> 큰 회사들이 사용하는 버전을 사용하는 것이 좋음

[https://cloud.google.com/composer/docs/concepts/versioning/composer-versions](https://cloud.google.com/composer/docs/concepts/versioning/composer-versions) 참고

## I. [airflow.cfg](http://github.com/mildsalmon/Study/blob/Airflow/Airflow/docs/airflow.cfg.md)

# 3. sql

## A. primary uniqueness

> 데이터 웨어하우스들은 Primary Key를 보장하지 않음

1. 임시 테이블(스테이징 테이블)을 만들고 거기로 현재 모든 레코드를 복사
2. 임시 테이블에 새로 데이터 소스에서 읽어들인 레코드들을 복사
	- 이때는 중복이 존재할 수도 있음
3. 중복을 걸러주는 SQL 작성
	- ROW_NUMBER를 이용해서 primary key로 partition을 잡고 다른 필드(보통 타임스탬프)로 ordering을 수행해서 primary key 별로 하나의 레코드를 찾아냄
4. 위의 SQL을 바탕으로 최종 원본 테이블로 복사 (swap) - 밑에 2가지 방법 중 하나 선택
	- 원본 테이블을 DROP하고, 임시 temp 테이블을 원본 테이블로 바꿔주기 (ALTER)
	- 원본 테이블 내용을 전부 DELETE하고 임시 temp 테이블을 INSERT 해주기

---

1. `CREATE TABLE [schema].[temp table] AS SELECT ~ FROM [schema].[table];`
	- 원래 테이블의 내용을 temp table로 복사
2. DAG는 임시 테이블(스테이징 테이블)에 레코드를 추가
	- 이때는 중복이 존재할 수도 있음
3. `DELETE FROM [schema].[table];`
4. `INSERT INTO [schema].[table] SELECT ~ FROM (SELECT ~, ROW_NUMBER() OVER (PARTITION BY [date] ORDER BY [create_date] DESC) seq FROM [schema].[temp table]) WHERE seq = 1;`

> 매번 새로 덮어쓰는 형식의 업데이트를 가정

- 3, 4번은 transaction으로 처리하는게 좋음
	- 3, 4번 실패시 전부 실패되는 것이 원자성을 보장할 수 있음
- 데이터 엔지니어링 관점에서는, 만약 1, 2번에서 실패하면 error를 발생시키고 다시 시작하면 됨
	- 1, 2번이 실패한다고 table의 문제가 생기지는 않음
	- 완벽하게 복구를 못할거면 그냥 fail하는게 나음.
	- **에러가 발생하면, 코드 안에서 recovery하지 말고 에러를 보여주는게 나음.**

```python

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

```

# 4. etc

## A. slack 연동하기

### a. 데이터 파이프라인 문제를 슬랙에 표시

- [https://api.slack.com/messaging/webhooks](https://api.slack.com/messaging/webhooks)
	- 위를 따라해서 Incoming Webhooks App 생성

### b. Webhook으로 메세지 보내기

```
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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
```

### c. 데이터 파이프라인 실패/경고를 슬랙으로 보내는 방법

- `T010X0Q2B5W/B037F7V21HD/Xu2cd5IUXbj19D1oaCSWLOqU`을 **slac_url** Variable로 저장
- slack에 에러 메세지를 보내는 별도 모듈로 개발
	- slack.py
- 이것을 DAG 인스턴스를 만들 때 에러 콜백(on_failure_callback, on_success_callback)으로 지정

```python

dag_second_assignment = DAG(
	dag_id = 'second_assignment_v4',
	start_date = datetime(2021,11,27), # 날짜가 미래인 경우 실행이 안됨
	schedule_interval = '0 2 * * *', # 적당히 조절
	max_active_runs = 1,
	catchup = False,
	default_args = {
		'retries': 1,
		'retry_delay': timedelta(minutes=3),
		'on_failure_callback': slack.on_failure_callback,
	}
)

```