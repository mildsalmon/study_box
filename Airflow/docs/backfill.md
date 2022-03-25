# Table of Contents

- [1. Backfill](#1-backfill)
- [2. Airflow의 Backfill 동작 방식](#2-airflow의-backfill-동작-방식)
    - [A. Daily Incremental Update를 구현해야 한다면?](#a-daily-incremental-update를-구현해야-한다면)
    - [B. Incremental하게 1년치 데이터를 Backfill해야 한다면?](#b-incremental하게-1년치-데이터를-backfill해야-한다면)
    - [C. start_date와 execution_date 이해하기](#c-start_date와-execution_date-이해하기)
- [3. How to Backfill in Airflow](#3-how-to-backfill-in-airflow)
    - [A. Backfill을 커맨드 라인에서 실행하는 방법](#a-backfill을-커맨드-라인에서-실행하는-방법)
    - [B. How to Make Your DAG Backfill ready](#b-how-to-make-your-dag-backfill-ready)
    - [C. 마지막으로 읽어온 레코드를 기반으로한 Incremental Update](#c-마지막으로-읽어온-레코드를-기반으로한-incremental-update)

---

# 1. Backfill

- 이미 읽어온 데이터가 있는데, 그 **데이터가 소스 쪽에서 바껴서 다시 읽어와야 하는 경우**에 사용한다.
- **데이터를 복사하고, 과거 데이터를 읽어오는** 것
- 코드 하나를 가지고 오늘부터 미래까지 운영할 수 있고, **과거에 문제가 생겼을 때 코드 변경 없이 airflow UI에서 해결**할 수 있다.

---

- scheduler에 등록된 backfill 작업을 취소하기는 어렵다.
	- UI에서 실행시킨 경우는 pause를 unpause로 변경시켜서 일시 정지시킬 수는 있지만, 취소는 되지 않는다.
	- command line에서 실행시킨 경우에는 ctrl + z로 중단할 수 있다.

---

- 실패한 데이터 파이프라인을 재실행하는 것이 쉬워야함.
- 과거 데이터를 다시 채우는 과정(Backfill)이 쉬워야함.
- Airflow는 이 부분(특히 backfill)에 강점을 갖고 있음
	- DAG의 catchup 파라미터가 True가 되어야하고 start_date와 end_date가 적절하게 설정되어야 함
	- 대상 테이블이 incremental update가 되는 경우에만 의미가 있음
		- execution_date 파라미터를 사용해서 업데이트되는 날짜 혹은 시간을 알아내게 코드를 작성해야함
		- 현재 시간을 기준으로 업데이트 대상을 선택하는 것은 안티 패턴

---

> 하나의 코드 베이스로 지금부터 미래의 데이터를 복사해오는 것을 지원하고, 필요한 경우 backfill을 지원하기도 함
> > airflow 코드를 만들 때 airflow에서 요구하는 형태로 코드를 작성해야 함

- backfill은 Incremental update를 한다는 것을 의미한다.
- Airflow에서는 **catchup**, **start_date**, **end_date** parameter를 통해서 backfill을 결정함.

# 2. Airflow의 Backfill 동작 방식

## A. Daily Incremental Update를 구현해야 한다면?

2020년 11월 7일부터 매일 하루치 데이터를 읽어온다고 가정.

- 이 경우 언제부터 해당 ETL이 동작해야 할까?
	- **2020년 11월 8일**
- 2020년 11월 8일부터 동작하지만, 읽어와야 하는 날짜는?
	- **2020년 11월 7일**
	- Airflow의 start_date는 시작 날짜라기보다는 읽어와야하는 데이터의 시작 시점 날짜임 (Incremental update job인 경우)

## B. Incremental하게 1년치 데이터를 Backfill해야 한다면?

- 날짜를 지정해주면 그 기간에 대한 데이터를 다시 읽어온다.
	- 모든 DAG 실행에는 **execution_date**가 지정되어 있음
	- execution_date로 채워야하는 날짜와 시간이 넘어옴
	- 이를 바탕으로 데이터를 갱신하도록 코드를 작성해야함

## C. start_date와 execution_date 이해하기

2020-08-10 02:00:00로 start_date가 설정된 daily job이 있다.  
catchup이 True로 설정되어 있다.

지금 시간이 2020-08-13 20:00:00이고 처음으로 이 job이 활성화되었다.

---

- 이때, 이 job은 몇 번 실행될까?
	- **3번**
		- 2020-08-11 02:00:00
			- 2020-08-10 02:00:00 ~ 2020:08:11 02:00:00이 실행됨
			- start_date
				- 2020-08-10 02:00:00
			- execution_date
				- 2020-08-10 02:00:00
		- 2020-08-12 02:00:00
			- 2020-08-11 02:00:00 ~ 2020:08:12 02:00:00이 실행됨
			- start_date
				- 2020-08-11 02:00:00
			- execution_date
				- 2020-08-11 02:00:00
		- 2020-08-13 02:00:00
			- 2020-08-12 02:00:00 ~ 2020:08:13 02:00:00이 실행됨
			- start_date
				- 2020-08-12 02:00:00
			- execution_date
				- 2020-08-12 02:00:00

# 3. How to Backfill in Airflow

## A. Backfill을 커맨드 라인에서 실행하는 방법

> 보통 backfill은 커맨드에서 실행함

`airflow dags backfill dag_id -s 2018-07-01 -e 2018-08-01`

- 아래 설정이 되어야만 backfill이 가능함
	- **catchup이 True**로 설정되어 있음
	- **execution_date를 사용해서 Incremental update가 구현**되어 있음
		- full refresh한 DAG면 backfill할 이유가 없음
- start_date부터 시작하지만, **end_date는 포함하지 않음**

## B. How to Make Your DAG Backfill ready

- 먼저 모든 DAG가 backfill을 필요로 하지는 않음
	- Full Refresh를 한다면 bacfill은 의미가 없음
- 여기서 backfill은 일별 혹은 시간별로 업데이트하는 경우를 의미함
	- 마지막 업데이트 시간 기준 backfill을 하는 경우(Data Warehouse 테이블에 기록된 시간 기준)에도 execution_date를 이용한 backfill은 필요하지 않음
- 데이터의 크기가 굉장히 커지면 backfill 기능을 구현해 두는 것이 필수
	- airflow가 큰 도움이 됨
	- 하지만 데이터 소스의 도움 없이는 불가능
- 어떻게 backfill을 구현할 것인가?
	- 제일 중요한 것은 데이터 소스가 backfill 방식을 지원해야함
	- "execution_date"을 사용해서 업데이트할 데이터 결정
	- "catchup"필드를 True로 설정
	- start_date / end_date를 backfill하려는 날짜로 설정
	- 다음으로 중요한 것은 DAG 구현이 execution_date을 고려해야 하는 것이고 idempotent 해야함.

## C. 마지막으로 읽어온 레코드를 기반으로한 Incremental Update

- 가장 최근 시각의 레코드나 가장 큰 레코드 ID를 기반으로 구현하는 것은 한 방법
	- DW에서 해당 데이터의 마지막 timestamp나 ID를 읽어온다.
	- 데이터 소스에서 그 이후로 만들어지거나 변경이 있는 레코드들만 읽어온다.
	- 이를 DW의 테이블에 추가한다. (append)
	- 만일 테이블이 Append only가 아닌 경우 변경이 생긴 레코드들의 경우 중복이 존재하기 때문에 이를 제거한다.
		- 가장 나중에 추가된 레코드만 남기고 나머지는 제거

