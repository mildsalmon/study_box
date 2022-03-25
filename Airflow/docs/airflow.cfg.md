# Table of Contents

- [1. airflow.cfg](#1-airflowcfg)
    - [A. 환경 설정 파일 수정을 반영하려면?](#a-환경-설정-파일-수정을-반영하려면)
    - [B. dags 폴더 스캔](#b-dags-폴더-스캔)
    - [C. Airflow Database upgrade](#c-airflow-database-upgrade)
    - [D. LocalExecutor 사용](#d-localexecutor-사용)
    - [E. Enable Authentication](#e-enable-authentication)
    - [F. Large disk volume for logs and local data](#f-large-disk-volume-for-logs-and-local-data)
    - [G. Periodic Log data cleanup](#g-periodic-log-data-cleanup)
    - [H. From Scale Up to Scale Out](#h-from-scale-up-to-scale-out)
    - [I. Backup Airflow database](#i-backup-airflow-database)
    - [J. Add health-check monitoring](#j-add-health-check-monitoring)
        - [a. Airflow API 활성화](#a-airflow-api-활성화)
        - [b. Health API 호출](#b-health-api-호출)
        - [c. API 사용예](#c-api-사용예)

---

# 1. airflow.cfg

## A. 환경 설정 파일 수정을 반영하려면?

```
sudo systemctl restart airflow-webserver
sudo systemctl restart airflow-scheduler
```

- `airflow db init`을 하면 airflow가 reset되버림
	- DAG가 등록된 내용, 과거에 DAG가 돌았던 기록 등이 사라짐

## B. dags 폴더 스캔

- Airflow는 dags 폴더를 주기적으로 스캔함.
	- dags 폴더에 있는 모든 파이썬 파일들을 스캔하는데, `from airflow import DAG`가 작성된 파일들만 더 구체적으로 스캔한다.
- 이때, DAG 모듈이 들어있는 모든 파일들의 메인 함수가 실행됨.
	- 본의 아니게 개발중인 테스트 코드도 실행될 수 있음
- DAG에 해당하는 파이썬 코드에는 DAG를 생성하는 코드와 task를 생성하는 코드 외에는 들어가면 안됨.

```
[core]
dags_folder = /var/lib/airflow/dags
# How often (in seconds) to scan the DAGs directory for new files. Default to 5 minutes.
dag_dir_list_interval = 300
```

- dags_folder
	- DAG들이 있는 디렉토리 위치
- dag_dir_list_interval
	- dags_folder를 airflow가 얼마나 자주 스캔하는지 명시 (초 단위)

## C. Airflow Database upgrade

- sqlite -> Postgres OR MySQL
- sql_alchemy_conn 변경

## D. LocalExecutor 사용

- Single Server
	- from SequentialExcecutor to LocalExecutor
- Cluster
	- from SequentialExecutor to CeleryExecutor or KubernetesExecutor

## E. Enable Authentication

- Airflow 1.0은 초기 로그인 화면이 default가 아니였음
- Airflow 2.0은 로그인 화면 ON이 default임.

## F. Large disk volume for logs and local data

- Logs -> /dev/airflow/logs in (Core section of airflow.cfg)
	- base_log_folder
	- child_process_log_directory
- Local data -> /dev/airflow/data

---

- local 등의 환경에서 직접 manage할 때부터 disk volume이 충분히 있는지를 확인하는 것이 중요함.
- log 파일들은 local에서 삭제하거나, S3에 별도로 업로드해서 관리하는 것이 좋음

## G. Periodic Log data cleanup

- 정기적으로 log 디렉토리는 지워야한다.
- 이 행동을 수행하는 shell Operator기반 DAG를 작성할 수 있다.

## H. From Scale Up to Scale Out

- Cloud Airflow를 고려

---

- worker가 여러개여도 scheduler는 한개임.
	- master scheduler가 죽으면 secondary scheduler가 실행되도록 설정하는 이중화가 필요함.
	- Airflow 2.0부터는 이런 것들을 보장하는 기능이 있음

## I. Backup Airflow database

- Airflow.cfg도 백업해야함.
	- core section에 있는 **fernet_key**가 대칭키 암호화 키임.
	- 이 키를 잃어버리면 meta database를 복구하지 못할수도 있음
- Backup Variables and Connections (command lines or APIs)
	- airflow Variables export variables.json
	- airflow Connections export connections.json

## J. Add health-check monitoring

- [https://airflow.apache.org/docs/apache-airflow/stable/logging-monitoring/check-health.html](https://airflow.apache.org/docs/apache-airflow/stable/logging-monitoring/check-health.html)
	- API를 먼저 활성화하고 Health Check Endpoint API를 모니터링 툴과 연동

---

- Scheduler가 살아있는지를 확인하는 monitor
	- Scheduler가 정상적으로 동작하는지를 확인하기 위해 Running 중인 Dag 수가 몇 개인지 체크
- Webserver가 살아있는지를 확인하는 monitor

### a. Airflow API 활성화

- api section에서 auth_backedn의 값을 변경

```

[api]
auth_backend = airflow.api.auth.backend.basic_auth

```

- airflow 스케줄러 재실행

```
   
sudo systemctl restart airflow-webserver
sudo systemctl restart airflow-scheduler # 아마도 불필요?

```

- basic_auth의 ID/Password 설정
	- Airflow 서버로 로그인해서 airflow 사용자로 변경(sudo su airflow)
	```
	
	airflow config get-value api auth_backend
	
	```

- Airflow Web UI에서 새로운 사용자 추가
	- Security -> List Users -> + -> 이후 화면에서 새 사용자 정보 추가 (monitor:MonitorUser1)
	- 모니터링만 가능할 정도로 권한을 최소한으로 줌

### b. Health API 호출

- /health API 호출 (앞서 생성한 사용자 정보 사용)

```
curl -X GET --user "Monitor:MonitorUser1" http://[AirflowServer]:8080/health
```

- 정상 응답

```

{
	"metadatabase": {
		"status": "healthy"
	},
		"scheduler": {
			"status": "healthy",
			"latest_scheduler_heartbeat": "2022-03-12T06:02:38.067178+00:00"
	}
}

```

- 응답이 온다는 것
	- Web Server가 살아있다는 의미
- metadatabase의 status
	- airflow가 사용하는 metadatabase의 이상 유무
- 스케줄러의 status
	- 스케줄러가 healthy여도 heartbeat 값이 최신이 아니면, 작동 안하는 것일 수도 있음.

### c. API 사용예

- [특정 DAG를 API로 Trigger하기](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#operation/post_dag_run)
- [모든 DAG 리스트하기](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#operation/get_dags)
- [모든 Variable 리스트하기](https://airflow.apache.org/docs/apache-airflow/stable/stable-rest-api-ref.html#tag/Variable)

