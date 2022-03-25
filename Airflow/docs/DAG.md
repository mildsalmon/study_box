# 1. DAG(directed acyclic graph)

> 위상 정렬
> > 방향을 가지며 순환하지 않는 그래프

- 하나의 data pipeline은 **다수의 task들의 집합**
- **task들 간에 실행 순서가 정의**됨
- **실행 순서는 Acyclic**함

![](/bin/DE7_image/DE7_7_5.png)

- DAG는 data pipeline이 해야하는 일들을 task들로 분리한 다음에 Task들 간에 실행 순서를 정한다.
	- DAG는 task의 집합이다.
	- **airflow에서는 task를 operator**라고 부름
		- operator마다 자기의 전문 분야가 있음
	- Task들 간에 실행 순서가 define되어야 함

## A. DAG Common Configuration

> 이것보다 더 많은 parameter를 사용할 수 있다.

```python

from datetime import datetime, timedelta
from airflow import DAG

default_args = {
	'owner': 'mildsalmon',
	'start_date': datetime(2020, 8, 7, hour=0, minute=00),
	'end_date': datetime(2020, 8, 31, hour=23, minute=00),
	'email': ['mildsalmon@gmail.com'],
	'retries': 1,
	'retry_delay': timedelta(minutes=3),
	'on_failure_callback': slack.on_failure_callback,
}

```

> `from airflow import DAG` 모듈이 항상 import되어야 한다.
> > Airflow가 DAG를 찾을때 DAG 모듈이 import되어 있는지를 확인하기 때문

- start_date
	- 시작하는 날짜
	- DAG는 start_date 다음 주기에 실행된다.
	- DAG가 실행되고 나서는 execute date = start date로 설정된다.
	- start_date, end_date는 이 dag가 시작되고 끝나기를 지정한다.
		- 1회성 backfill에 사용될 수 있다.
- end_date
	- 보통 안적음
	- 데이터 소스가 변경되어서 지난 1년치 데이터를 다시 읽어야 하는 경우에 사용
- email
	- DAG가 동작하다가 fail이 발생했을 때 이메일 보낼 곳
- retries
	- faile이 발생했을 때 retry 횟수
- retry_delay
	- faile이 발생하고 얼마나 retry하기까지의 지연시간
- on_failure_callback
	- 실패했을 경우의 동작할 내용

## B. DAG Object Creation

```python

test_dag = DAG(
	"dag_v1", # DAG name
	# schedule (same as cronjob)
	schedule_interval="0 9 * * *",
	# common settings
	default_args=default_args
	catchup=False
	max_active_runs=1
	concurrency=13
)

```

> DAG라는 class를 가지고 내가 구현하려고 하는 DAG에 대한 meta 정보(configuration)을 입력해야 한다.

> 아래 파라미터들은 모두 DAG 파라미터로 DAG 객체를 만들 때 지정해주어야함
> default_args로 지정해주면 에러는 안나지만, 적용이 안됨.

- DAG name
	- Web UI에 나타나는 정보
	- DAG 이름과 DAG 파일의 이름을 동일하게 맞춰주는 것과 같이 convention을 갖는게 유지보수할 때 편함
- schedule_interval
	- Linux cron과 동일함
- default_args
	- 위에서 작성한 configuration을 지정
	- DAG에 적용되는 것이 아닌 **Task에 적용**됨
- catchup
	- start_date(execution_date)와 현재 시간을 봤을 때, start_date(execution_date)이 과거인 경우 그 사이에 밀린 task들을 어떻게 할지를 결정하는 parameter
	- 밀린 task들이 있다면 실행(catchup)해라
	- catachup이 False이면 과거는 신경쓰지 않고 미래를 동작한다.
- max_active_runs
	- 한번에 DAG에 몇개의 instance가 동시에 실행될 수 있는지를 지정
	- backfill할 때 중요
	- 리소스를 지정한 갯수만큼 할당할 수 있어야함.
		- 이 파라미터의 upper bound는 해당 서버의 CPU 개수에 의해 결정됨
- concurrency
	- dag 안에서 동시에 실행될 수 있는 task의 수

# 2. Redshift Bulk Update : COPY (MySQL -> S3 -> Redshift)

## A. COPY 명령

> COPY 명령은 중복제거, full refresh 신경쓰지 않고, S3 위치에 있는 파일을 Redshift에 loading하는 것만 함.

```
COPY mildsalmon_su.nps
FROM 's3://grepp-data-****/mildsalmon-nps'
with credentials 'aws_iam_role=***'
csv;

# S3 위치에 있는 파일을 Redshift 위치에 복사해라.
COPY {Destination 위치}
FROM {S3 위치}
with credentials 'aws_iam_role=***'
csv;

```

- with credentials
	- 이 명령을 실행하는 사람이 S3에 대한 접근 권한이 있다는 것을 지정
- csv
	- S3에 있는 파일의 포멧 지정

## B. Full Refresh

> MySQL에 있는 테이블 nps를 Redshift 내의 스키마 밑의 nps 테이블로 복사
> > S3를 경유해서 COPY 명령으로 Redshift에 복사

- 3개의 Operator를 사용해서 구현
	- [[Operator#b S3DeleteObjectsOperator]]
	- [[Operator#c MySQLToS3Operator]]
	- [[Operator#d S3ToRedshiftOperator]]

> Airflow에서 기본으로 제공되는 S3 관련된 기능들이 그렇게 좋지 않음
> 그래서 많은 경우 python에서 AWS를 조작하는데 사용되는 **boto3 library**를 사용하여 직접 구현함.

## C. Incremental Update

> Incremental Update가 가능하고, Backfill을 하는데 사용할 수 있다.

- MySQL/PostgreSQL 테이블이 Daily update이고 테이블의 이름이 A이고 MySQL에서 데이터를 읽어온다면.
	- 먼저 Redshift의 A테이블의 내용을 temp_A로 복사
	- MySQL의 A테이블의 레코드 중 modified의 날짜가 지난 일(execution_date)에 해당하는 모든 레코드를 읽어다가 temp_A로 복사
		- `SELECT * FROM A WHERE DATE(modified) = DATE({execution_date})`
			- backfill을 하려면, airflow에서 넘겨주는 execution date를 보고 modified timestamp를 정한다.
	- temp_A의 레코드들을 primary key를 기준으로 파티션한 다음에 modified 값을 기준으로 DESC 정렬하여, 일련번호가 1인 것들만 다시 A로 복사

---

- 3개의 Operator를 사용해서 구현
	- [[Operator#b S3DeleteObjectsOperator]]
	- [[Operator#ㄴ Incremental Update]]
		- execution_date에 해당하는 레코드만 읽어오게 바뀜
	- 자체 구현한 [[Operator#ㄴ Incremental Update를 위해 자체 구현]]
		- plugins 폴더

# 3. summary table 구현

## A. 간단한 Summary Table DAG 구현

### a. 테스트 방법

- Summary Table을 만들떄는 임시 테이블을 만들고 다양한 테스트를 해야 한다.
	- 레코드가 1개 이상 있는가? 등
	- 테스트가 성공하면, 그때 테이블을 교체한다.

```python

cur.execute("SELECT COUNT(1) FROM {schema}.temp_{table}""".format(schema=schema, table=table))
count = cur.fetchone()[0]
if count == 0:
	raise ValueError("{schema}.{table} didn't have any record".format(schema=schema, table=table))

```

### b. DAG안에 params로 query 입력

```python

execsql = PythonOperator(
    task_id = 'execsql',
    python_callable = execSQL,
    params = {
        'schema' : 'keeyong',
        'table': 'channel_summary',
        'sql' : """SELECT
	DISTINCT A.userid,
        FIRST_VALUE(A.channel) over(partition by A.userid order by B.ts rows between unbounded preceding and unbounded following) AS First_Channel,
        LAST_VALUE(A.channel) over(partition by A.userid order by B.ts rows between unbounded preceding and unbounded following) AS Last_Channel
        FROM raw_data.user_session_channel A
        LEFT JOIN raw_data.session_timestamp B ON A.sessionid = B.sessionid;"""
    },
    provide_context = True,
    dag = dag
)

```

- params에 들어가는 내용을 airflow configuration에 지정해서 코드 변경없이도 할 수 있음

### c. config 파일로 만들기

> 코드라기 보다는 환경 설정 파일을 만들어서 설정한다.

파이썬 딕셔너리를 만들어서 params를 입력하고 DAG에 가져와서 사용한다.

#### ㄱ) config 파일

```python

{
	'table': 'nps_summary',
	'schema': 'keeyong',
	'main_sql': """SSELECT LEFT(created_at, 10) AS date,
				ROUND(SUM(CASE
				WHEN score >= 9 THEN 1
				WHEN score <= 6 THEN -1 END)::float*100/COUNT(1), 2)
				FROM keeyong.nps
				GROUP BY 1
				ORDER BY 1;""",
	'input_check':
	[
		{
			'sql': 'SELECT COUNT(1) FROM keeyong.nps',
			'count': 150000
		},
	],
	'output_check':
	[
		{
			'sql': 'SELECT COUNT(1) FROM {schema}.temp_{table}',
			'count': 12
		}
	],
}

```

> summary table을 만들기 전에 input_check를 통해 원하는 형태의 조건을 만족하는지를 체크한다.

- input_check
	- CTAS하기 전에 실행된다.
	- list 형태로 만들어져서, 다수의 test를 붙일 수 있다
- output_check
	- 최종적으로 만들어진 table에 다양한 조건들을 확인할 수 있다.
	- primary key uniqueness하다는 것을 검증한다.
- input_check나 output_check가 실패하면 summary table을 만드는 작업을 Fail하고 이전 상태를 유지한다.

#### ㄴ) dag

```python

DAG_ID = "Build_Summary_v2"
dag = DAG(
    DAG_ID,
    schedule_interval="25 13 * * *",
    max_active_runs=1,
    concurrency=1,
    catchup=False,
    start_date=datetime(2021, 9, 17),
    default_args= {
        'on_failure_callback': slack.on_failure_callback,
        'retries': 1,
        'retry_delay': timedelta(minutes=1),
    }
)

# this should be listed in dependency order (all in analytics)
tables_load = [
    'nps_summary'
]

dag_root_path = os.path.dirname(os.path.abspath(__file__))
redshift_summary.build_summary_table(dag_root_path, dag, tables_load, "redshift_dev_db")

```