# 1. Operator

## A. Operators Creation

### a. example 1

```python

t1 = BashOperator(
 task_id='print_date',
 bash_command='date',
 dag=test_dag)

t2 = BashOperator(
 task_id='sleep',
 bash_command='sleep 5',
 retries=3,
 dag=test_dag)

t3 = BashOperator(
 task_id='ls',
 bash_command='ls /tmp',
 dag=test_dag)

t1 >> t2 # t2.set_upstream(t1)
t1 >> t3 # t3.set_upstream(t1)

```

![](/bin/DE7_image/DE7_7_7.png)

- t1 >> t2 (실행 순서)
	- t1이 끝나면 t2, t3를 동시에 실행하라는 의미

### b. example 2

```python

start = DummyOperator(dag=dag, task_id="start", *args, **kwargs)

t1 = BashOperator(
 task_id='ls1',
 bash_command='ls /tmp/downloaded',
 retries=3,
 dag=dag)

t2 = BashOperator(
 task_id='ls2',
 bash_command='ls /tmp/downloaded',
 dag=dag)

end = DummyOperator(dag=dag, task_id='end', *args, **kwargs)

start >> t1 >> end
start >> t2 >> end 

# 위와 동일하게 동작함
# start >> [t1, t2] >> end

```

![](/bin/DE7_image/DE7_7_8.png)

- 실행 순서
	- start -> t1, t2 -> end
- DummyOperator
	- 아무것도 안하는 Operator

### c. example 3

```python

print_hello = PythonOperator(
	task_id = 'print_hello',
	python_callable = print_hello,
	dag = dag
)

print_goodbye = PythonOperator(
	task_id = 'print_goodbye',
	python_callable = print_goodbye,
	dag = dag
)

```

- task_id
	- task_id를 지정하면 DAG 안에서 특정 task의 식별자가 된다.
- python_callable
	- 실행시킬 python 함수
- 실행 순서
	- task 실행 순서를 적어주지 않으면, task가 순서없이 각각 개별적으로 실행됨.

## B. task를 나누는 경우 장/단점

### a. 장점

- 중간에 task가 실패한 부분부터 다시 실행할 수 있음

### b. 단점

- 복잡도가 늘어남
	- 각 task들이 스케줄됨
		- airflow가 더 바빠지고 실행 시간이 늘어날 수 있음
	- 각 task들 간에 데이터를 넘겨주는 것이 명확하게 보이지 않음
	- 넘겨주는 데이터가 엄청 크다면, 어딘가에 저장하고 데이터의 path를 리턴하여 읽어오는 방식으로 구현한다.
		- xcom으로 큰 데이터 처리는 어려움

## C. task를 어느 정도로 분리하는 것이 좋을까?

> 오래 걸리는 DAG는 실패시 재실행이 쉽게 다수의 task로 나누는 것이 좋음

- task를 많이 만들면 전체 DAG가 실행되는데 오래 걸리고 스케줄러에 부하가 감
	- task의 수가 Airflow 전체 performance에 영향을 많이 줌
	- task를 너무 잘게 분해하면 오히려 안좋음
- task를 너무 적게 만들면 모듈화가 안되고 실패시 재실행 시간이 오래 걸림

---

- 중간에 Fail했을 때 처음부터 다시 시작할 필요가 없게끔 task 수를 나누는 것이 좋음
	- 단, 너무 잘게 쪼개는 것은 비추천
- DAG 수가 늘어나거나 task 수가 늘어나면, 스케줄 되는 것만으로도 시간이 꽤 걸림

## D. Operators

### a. PythonOperator

```python

from airflow.exceptions import AirflowException

def python_func(**context):
	table = context["params"]["table"]
	schema = context["params"]["schema"]
	ex_date = context["execution_date"]

load_nps = PythonOperator(
	dag=dag,
	task_id = 'task_id',
	python_callable=python_func,
	params={
		'table': 'delighted_nps',
		'schema': 'raw_data'
	},
	provide_context=True
)

```

- provide_context / params
	- python_callable 함수에 파라미터로 넘길때
		- provide_context의 값을 True로 지정
		- params에 인자들을 dict 형태로 지정
	- python 함수에서는 context에서 params dict 안에 인자값을 받아올 수 있음
		- context를 통해 airflow에서 유지하는 다양한 system variable들을 읽어올 수 있음
			- ex) execution_date

### b. S3DeleteObjectsOperator

- MySQLToS3Operator에는  S3 key 덮어쓰기 기능이 없다.
	- 지금 업로드 하려고 하는 S3 bucket 밑에 S3 path에 S3 key에 뭔가가 조재한다면 에러가 발생함.
- S3 key를 지워주는 역할

```python

# s3_key가 존재하지 않으면 에러를 냄! 
s3_folder_cleanup = S3DeleteObjectsOperator(
    task_id = 's3_folder_cleanup',
    bucket = s3_bucket,
    keys = s3_key,
    aws_conn_id = "aws_conn_id",
    dag = dag
)

```

### c. MySQLToS3Operator

#### ㄱ) Full Refresh

```python

mysql_to_s3_nps = MySQLToS3Operator(
    task_id = 'mysql_to_s3_nps',
    query = "SELECT * FROM prod.nps",
    s3_bucket = s3_bucket,
    s3_key = s3_key,
    mysql_conn_id = "mysql_conn_id",
    aws_conn_id = "aws_conn_id",
    verify = False,
    dag = dag
)

```

- mysql_conn_id
	- mysql에 접속하기 위해 connection id를 지정
- aws_conn_id
	- S3에 접속하기 위해 connection id를 지정
- s3_bucket
	- s3 bucket 주소
	- top-level-directory
		- ex) grepp-data...

#### ㄴ) Incremental Update

> mysql_to_s3_nps TASK가 실행되면, S3 bucket에 csv 파일을 떨구게 됨

```python

mysql_to_s3_nps = MySQLToS3Operator(
	task_id = 'mysql_to_s3_nps',
	query = "SELECT * FROM prod.nps WHERE DATE(created_at) = DATE('{{ execution_date }}')",
	s3_bucket = s3_bucket,
	s3_key = s3_key,
	mysql_conn_id = "mysql_conn_id",
	aws_conn_id = "aws_conn_id",
	verify = False,
	dag = dag
)

```

- DATE('{{ execution_date }}')
	- `{{ }}`는 flask의 Jinja Template 표기법
	- PythonOperator를 사용할 때는 PythonOperator 함수의 Context 파라미터의 execution date를 읽어왔는데, Jinja Template을 사용해서 얻어올 수도 있음
	- `{{ }}`안에 있는 변수를 Airflow Variable로 치환해줌
		- airflow variable은 [Templates reference — Airflow Documentation (apache.org)](https://airflow.apache.org/docs/apache-airflow/stable/templates-ref.html) 여기에 나와 있음

### d. S3ToRedshiftOperator

#### ㄱ) Full Refresh

```python

s3_to_redshift_nps = S3ToRedshiftOperator(
    task_id = 's3_to_redshift_nps',
    s3_bucket = s3_bucket,
    s3_key = s3_key,
    schema = schema,
    table = table,
    copy_options=['csv'],
    truncate_table = True,
    redshift_conn_id = "redshift_dev_db",
    dag = dag
)

```

- redshift_conn_id
	- redshift에 접속하기 위해 connection id를 지정
- copy_options
	- MySQLToS3Operator가 file을 S3에 올릴 때 csv 파일로 올림
	- COPY command를 실행할 때, 파일 포멧을 알려줘야 함.
- schema
	- redshift schema
- table
	- redshift 안에 어느 table에 저장할 것인지.
- truncate_table
	- default가 False
	- table을 새로만드는 것이 아닌, record들을 계속 새로 적재한다.
		- full refresh

#### ㄴ) Incremental Update를 위해 자체 구현

> Upsert
> > 업데이트를 진행할 때, 만족하는 row가 있다면 update를 하고, 없다면 insert를 하는 것을 의미

```python

s3_to_redshift_nps = S3ToRedshiftOperator(
	task_id = 's3_to_redshift_nps',
	s3_bucket = s3_bucket,
	s3_key = s3_key,
	schema = schema,
	table = table,
	copy_options=['csv'],
	redshift_conn_id = "redshift_dev_db",
	primary_key = "id",
	order_key = "created_at",
	dag = dag
)

```

-  자체 구현한 S3ToRedshiftOperator
	- primary key와 order key를 가지고 같은 partition 안에서 ordering을 함
	- 기존에 있는 S3ToRedshiftOperator는 Upsert 기능이 없음
		- 중복이 생겼을 때, 중복을 제거해주는 기능이 없음

> Incremental Update 부분

```python

def generate_after_query(self, postgres_hook):
	if self.primary_key is not None and self.order_key is not None:
		columns = self.get_columns_from_table(postgres_hook)
		return f"""
			CREATE TEMPORARY TABLE T AS SELECT {columns}
			FROM (
				SELECT *, ROW_NUMBER() OVER (PARTITION BY {self.primary_key} ORDER BY {self.order_key} DESC) n
				FROM {self.schema}.{self.table}
			)
			WHERE n = 1;
			DELETE FROM {self.schema}.{self.table};
			INSERT INTO {self.schema}.{self.table} SELECT * FROM T;
		"""
	else:
		return ''
		
```