# Table of Contents

- [1. SQL의 소개](#1-sql의-소개)
    - [A. SQL (Structured Query Language)](#a-sql-structured-query-language)
    - [B. SQL의 분류](#b-sql의-분류)
- [2. SQL를 이용한 데이터 정의](#2-sql를-이용한-데이터-정의)
    - [A. SQL의 데이터 정의 기능](#a-sql의-데이터-정의-기능)
- [3. SQL을 이용한 데이터 조작](#3-sql을-이용한-데이터-조작)
    - [A. SQL의 데이터 조작 기능](#a-sql의-데이터-조작-기능)

---

# 1. SQL의 소개

## A. SQL (Structured Query Language)

- 관계 데이터베이스를 위한 표준 질의어
- 1974년에 IBM 연구소에서 데이터베이스 시스템. "시스템 R"을 질의하기 위해서 만들어진 구조화된 언어
- 미국 표준 연구소인 ANSI와 국제 표준화 기구인 ISO에서 표준화 작업을 진행
	- 1999년 SQL-99(SQL3)까지 표준화 작업이 완료된 후 계속 수정 및 보완되고 있음

![](/bin/db_image/db_10_1.png)

## B. SQL의 분류

![](/bin/db_image/db_10_2.png)

### a. 데이터 정의어 (DDL)

- 테이블을 생성하고 변경, 제거하는 기능을 제공
- 객체 생성 및 변경 시 사용

```ad-note

- CREATE
	- 테이블 생성
- ALTER
	- 테이블 변경
- DROP
	- 테이블 삭제

```

### b. 데이터 조작어 (DML)

- 테이블에 새 데이터를 삽입하거나, 테이블에 저장된 데이터를 수정, 삭제, 검색하는 기능을 제공
- 데이터 변경 시 사용

```ad-note

- SELECT
	- 데이터 검색 시 사용
- INSERT
	- 데이터 입력
- UPDATE
	- 데이터 수정
- DELETE
	- 데이터 삭제

```

### c. 데이터 제어어 (DCL)

- 보안을 위해 데이터에 대한 접근 및 사용 권한을 사용자별로 부여하거나 취소하는 기능을 제공

# 2. SQL를 이용한 데이터 정의

## A. SQL의 데이터 정의 기능

- 테이블을 생성, 변경, 제거

```ad-note

- CREATE
	- 테이블 생성
- ALTER
	- 테이블 변경
- DROP
	- 테이블 삭제

```

### a. 테이블 생성 (CREATE TABLE)

![](/bin/db_image/db_10_3.png)

#### ㄱ. 속성의 정의

- 테이블을 구성하는 각 **속성의 데이터 타입을 선택**한 다음 **널 값 허용 여부**와 **기본 값 필요 여부**를 결정
- NOT NULL
	- 속성이 널 값을 허용하지 않음을 의미하는 키워드
		```ad-example

		고객아이디 VARCHAR(20) NOT NULL

		```
- DEFAULT
	- 속성의 기본 값을 지정하는 키워드
		```ad-example

		- 적립금 INT DEFAULT 0
		- 담당자 VARCHAR(10) DEFAULT '방경아'

		```

#### ㄴ. 키의 정의

- PRIMARY KEY
	- 기본키를 지정하는 키워드
		```ad-example

		- PRIMARY KEY(고객아이디)
		- PRIMARY KEY(주문고객, 주문제품)

		```
	- UNIQUE
		- 대체키를 지정하는 키워드
		- 대체키로 지정되는 속성의 값은 유일성을 가지며 기본키와 달리 널 값이 허용됨
		```ad-example

		- UNIQUE(고객이름)

		```
	- FOREIGN KEY
		- 외래키를 지정하는 키워드
		- 외래키가 어떤 테이블의 무슨 속성을 참조하는지 REFERENCES 키워드 다음에 제시
		```ad-example

		- FOREIGN KEY(소속부서) REFERENCES 부서(부서번호)

		```

#### ㄷ. 데이터 무결성 제약조건의 정의

- CHECK
	- 테이블에 정확하고 유효한 데이터를 유지하기 위해 특정 속성에 대한 제약조건을 지정
	- CONSTRAINT 키워드와 함께 고유의 이름을 부여할 수도 있음
		```ad-example

		- CHECK(재고량 >= 0 AND 재고량 <= 10000)
		- CONSTRAINT CHK_CPY CHECK(제조업체='한빛제과')

		```

#### ㄹ. CREATE TABLE문 작성 예

##### 1) 고객 테이블 생성

```sql

CREATE TABLE 고객(
	고객아이디 VARCHAR(20) NOT NULL,
	고객이름 CHAR(10) NOT NULL,
	나이 INT,
	등급 CHAR(10) NOT NULL,
	직업 CHAR(10),
	적립금 INT DEFAULT 0,
	PRIMARY KEY(고객아이디)
);

```

##### 2) 제품 테이블 생성

```sql

CREATE TABLE 제품(
	제품번호 VARCHAR(5) NOT NULL,
	제품명 CHAR(20),
	재고량 INT,
	단가 INT,
	제조업체 CHAR(20),
	PRIMARY KEY(제품번호),
	CHECK (재고량 >= 0 AND 재고량 <= 10000)
);

```

##### 3) 주문 테이블 생성

```sql

CREATE TABLE 주문(
	주문번호 INT NOT NULL,
	주문고객 VARCHAR(20),
	주문제품 VARCHAR(3),
	수량 INT,
	베송지 CHAR(30),
	주문일자 DATETIME,
	PRIMARY KEY(주문번호),
	FOREIGN KEY(주문고객) REFERENCES 고객(고객아이디),
	FOREIGN KEY(주문제품) REFERENCES 제품(제품번호)
);

```

### b. 테이블 변경 (ALTER TABLE)

#### ㄱ) 새로운 속성 추가

![](/bin/db_image/db_10_4.png)

##### 1) 고객 테이블에 가입날짜 추가

```sql

ALTER TABLE 고객 ADD 가입날짜 DATETIME;

```

#### ㄴ) 기존 속성 삭제

![](/bin/db_image/db_10_5.png)

- CASCADE
	- 삭제할 속성과 관련된 제약조건이나 참조하는 다른 속성을 함께 삭제
- RESTRICT
	- 삭제할 속성과 관련된 제약조건이나 참조하는 다른 속성이 존재하면 삭제 거부

##### 1) 고객 테이블의 등급 속성을 삭제하면서 관련된 제약조건을 참조하는 다른 속성도 삭제

```sql

ALTER TABLE 고객 DROP 등급 CASCASDE;

```

### c. 테이블 제거 (DROP TABLE)

![](/bin/db_image/db_10_6.png)

- CASCADE
	- 제거할 테이블을 참조하는 다른 테이블도 함께 제거
- RESTRICT
	- 제거할 테이블을 참조하는 다른 테이블이 존재하면 제거 거부

##### 1) 고객 테이블을 삭제하되, 참조하는 다른 테이블이 존재하면 삭제가 되지 않게함

```sql

DROP TABLE 고객 RESTRICT;

```

# 3. SQL을 이용한 데이터 조작

## A. SQL의 데이터 조작 기능

- 데이터 검색, 새로운 데이터 삽입, 데이터 수정, 데이터 삭제

```ad-note

- SELECT
	- 데이터 검색 시 사용
- INSERT
	- 데이터 입력
- UPDATE
	- 데이터 수정
- DELETE
	- 데이터 삭제

```

### a. 데이터 검색 (SELECT)

#### ㄱ. 기본 검색

- SELECT 키워드와 함께 검색하고 싶은 속성의 이름 나열
- FROM 키워드와 함께 검색하고 싶은 속성이 있는 테이블의 이름 나열
- 검색 결과는 테이블 형태로 반환됨

![](/bin/db_image/db_10_7.png)

- ALL
	- 결과 테이블이 튜플의 중복을 허용하도록 지정
	- 생략 가능
- DISTINCT
	- 결과 테이블이 튜플의 중복을 허용하도록 지정

##### 1) 고객 테이블에서 고객아이디, 고객이름, 등급 속성 검색

```sql

SELECT 고객아이디, 고객이름, 등급
FROM 고객
;

```

##### 2) 고객 테이블에서 모든 속성 검색

```sql

SELECT *
FROM 고객
;

```

##### 3) 제품 테이블에서 제조업체를 중복없이 검색

```sql

SELECT DISTINCT(제조업체)
FROM 고객
;

```

##### 4) AS 키워드를 통해 속성의 이름을 바꾸어 출력

```sql

SELECT 단가 AS 가격
FROM 제품
;

```

#### ㄴ. 산술식을 이용한 검색

- SELECT 키워드와 함께 산술식 제시
	- 산술식
		- 속성의 이름과 +, -, \*, / 등의 산술 연산자와 상수로 구성
- 속성의 값이 실제로 변경되는 것은 아니고 결과 테이블에서만 계산된 결과값이 출력됨

##### 1) 제품 테이블에서 단가에 500원을 더해서 조정단가를 출력

```sql

SELECT 단가, 단가 + 500 AS 조정단가
FROM 제품
;

```

#### ㄷ. 조건 검색

- 조건을 만족하는 데이터만 검색

![](/bin/db_image/db_10_8.png)

- WHERE 키워드와 함께 비교 연산자(<, >, <=, >=, =, !=)와 논리 연산자(AND, OR, NOT)를 이용한 검색 조건 제시
	- 숫자뿐만 아니라 문자나 날짜 값을 비교하는 것도 가능
		```ad-example

		- 'A' < 'C'
		- '2013-12-01' < '2013-12-02'

		```
	- 조건에서 문자나 날짜 값은 작은 따옴표로 묶어서 표현

![](/bin/db_image/db_10_9.png)

##### 1) 제품 테이블에서 한빛제과가 제조한 제품만 검색

```sql

SELECT 제품명, 재고량, 단가
FROM 제품
WHERE 제조업체 = '한빛제과'
;

```

##### 2) 주문 테이블에서 apple 고객에 15개 이상 주문한 내용을 검색

```sql

SELECT 주문제품, 수량, 주문일자
FROM 주문
WHERE 주문고객 = 'apple'
	AND 수량 >= 15
;

```

#### ㄹ. LIKE를 이용한 검색

- LIKE 키워드를 이용해 부분적으로 일치하는 데이터를 검색
- 문자열을 이용하는 조건에만 LIKE 키워드 사용 가능

![](/bin/db_image/db_10_10.png)

##### 1) 성이 김씨인 고객을 검색

```sql

SELECT 고객이름
FROM 고객
WHERE 고객이름 LIKE '김%'
;

```

##### 2) 고객아이디가 5자인 고객을 검색

```sql

SELECT 고객아이디
FROM 고객
WHERE 고객아이디 LIKE '_____'
;

```

#### ㅁ. NULL을 이용한 검색

- IS NULL 키워드를 이용해 검색 조건에서 특정 속성의 값이 널 값인지를 비교
- IS NOT NULL 키워드를 이용하면 특정 속성의 값이 널 값이 아닌지를 비교

##### 1) 고객 테이블에서 나이가 입력되지 않은 고객이름 검색

```sql

SELECT 고객이름
FROM 고객
WHERE 나이 IS NULL
;

```

#### ㅂ. 정렬 검색

- ORDER BY 키워드를 이용해 결과 테이블 내용을 사용자가 원하는 순서로 출력
- ORDER BY 키워드와 함께 정렬 기준이 되는 속성과 정렬 방식을 지정
	- 오름차순(ASC)
	- 내림차순(DESC)
	- 여러 기준에 따라 정렬하려면 정렬 기준이 되는 속성을 차례대로 제시

![](/bin/db_image/db_10_11.png)

##### 1) 고객 테이블에서 나이를 기준으로 내림차순 정렬

```sql

SELECT 나이
FROM 고객
ORDER BY 1 DESC
;

```

#### ㅅ. 집계 함수를 이용한 검색

- 특정 속성 값을 통계적으로 계산한 결과를 검색하기 위해 집계 함수를 이용
	- 집계 함수(aggregation function)
		- COUNT, SUM, AVG, MAX, MIN의 계산 기능을 제공
- 집계 함수 사용 시 주의 사항
	- 집계 함수는 NULL인 속성 값은 제외하고 계산함
	- 집계 함수는 WHERE절에서는 사용할 수 없고 SELECT절이나 HAVING 절에서만 사용 가능

##### 1) 제품 테이블에서 모든 제품의 단가 평균을 검색

```sql

SELECT AVG(단가)
FROM 제품
;

```

##### 2) 속성을 이용해 COUNT

```sql

SELECT COUNT(단가)
FROM 제품
;

```

##### 3) 모든 속성 COUNT

- 특정 속성이 NULL값이여도 같이 COUNT

```sql

SELECT COUNT(*)
FROM 제품
;

```

#### ㅇ. 그룹별 검색

![](/bin/db_image/db_10_12.png)

- GROUP BY 키워드를 이용해 특정 속성의 값이 같은 튜플을 모아 그룹을 만들고, 그룹별로 검색
	- GROUP BY 키워드와 함께 그룹을 나누는 기준이 되는 속성을 지정
- HAVING 키워드를 함께 이용해 그룹에 대한 조건을 작성
- 그룹을 나누는 기준이 되는 속성을 SELECT절에도 작성하는 것이 좋음

##### 1) 주문 테이블에서 주문제품별 수량의 합계 검색

```sql

SELECT 주문제품, SUM(수량)
FROM 주문
GROUP BY 주문제품
;

```

##### 2) 제품 테이블에서 제품을 3개 이상 제조한 제조업체별로 제품의 수와 가장 비싼 단가를 검색

```sql

SELECT 제조업체, COUNT(*), MAX(단가)
FROM 제품
GROUP BY 제조업체
HAVING COUNT(*) >= 3
;

```

#### ㅈ. 여러 테이블에 대한 조인 검색

- 조인 검색
	- 여러 개의 테이블을 연결하여 데이터를 검색하는 것
- 조인 속성
	- 조인 검색을 위해 테이블을 연결해주는 속성
		- 연결하려는 테이블 간에 조인 속성의 이름은 달라도 되지만 도메인은 같아야 함
		- 일반적으로 외래키가 조인 속성으로 이용됨
- FROM 절에 검색에 필요한 모든 테이블을 나열
- WHERE 절에 조인 속성의 값이 같아야 함을 의미하는 조인 조건을 제시
- 같은 이름의 속성이 서로 다른 테이블에 존재할 수 있기 때문에 속성 이름 앞에 해당 속성이 소속된 테이블의 이름을 표시
	```ad-example

	주문, 주문고객

	```

- INNER JOIN ~ ON
- LEFT JOIN ~ ON
- RIGHT JOIN ~ ON
- CROSS JOIN ~ ON
- 셀프조인
- FULL JOIN ~ ON

##### 1) 판매 데이터베이스에서 banana고객이 주문한 제품의 이름을 검색

```sql

SELECT 제품.제품명
FROM 주문
JOIN 제품 ON (제품.제품번호 = 주문.주문번호)
WHERE 주문.주문고객 = 'banana'
;

```

#### ㅊ. 부속 질의문을 이용한 검색

- SELECT 문 안에 또 다른 SELECT 문을 포함하는 질의
	- 상위 질의문(주 질의문)
		- 다른 SELECT 문을 포함하는 SELECT 문
	- 부속 질의문 (서브 질의문)
		- 다른 SELECT 문 안에 내포된 SELECT 문
			- 괄호로 묶어서 작성
			- ORDER BY 절을 사용할 수 없음
		- 단일 행 부속 질의문
			- 하나의 행을 결과로 반환
		- 다중 행 부속 질의문
			- 하나 이상의 행을 결과로 반환
- 부속 질의문을 먼저 수행하고, 그 결과를 이용해 상위 질의문을 수행
- 부속 질의문과 상위 질의문을 연결하는 연산자가 필요
	- 단일 행 부속 질의문은 비교 연산자 (=, <>, <, <=, >, >=) 사용 가능
	- 다중 행 부속 질의문은 비교 연산자 사용 불가

![](/bin/db_image/db_10_13.png)

##### 1) 판매 데이터베이스에서 달콤비스켓과 같은 제조업체에서 제조한 제품의 제품명과 단가를 검색

```sql

SELECT 제품명, 단가
FROM 제품
WHERE 제조업체 = (
		SELECT 제조업체
		FROM 제품
		WHERE 제품명 = '달콤비스켓'
	)
;

```

##### 2) 판매 데이터베이스에서 banana 고객이 주문한 제품의 제품명과 제조업체를 검색

```sql

SELECT 제품명, 제조업체
FROM 제품
WHERE 제품번호 IN (
		SELECT 주문제품
		FROM 주문
		WHERE 주문고객 = 'banana'
	)
;

```

### b. 데이터 삽입 (INSERT)

#### ㄱ. 데이터 직접 삽입

![](/bin/db_image/db_10_14.png)

- INTO 키워드와 함께 튜플을 삽입할 테이블의 이름과 속성의 이름을 나열
	- 속성 리스트를 생략하면 테이블을 정의할 때 지정한 속성의 순서대로 값이 삽입됨
- VALUES 키워드와 함께 삽입할 속성 값들을 나열
- INTO 절의 속성 이름과 VALUES 절의 속성 값은 순서대로 일대일 대응되어야 함

##### 1) 고객 테이블에 고객아이디가 mild, 고객이름이 최유정을 삽입해보자

```sql

INSERT INTO 고객(고객아이디, 고객이름) VALUES('mild', '최유정');
INSERT INTO 고객 VALUES('mild', '최유정');

```

##### 2) 고객 테이블에 고객아이디가 salmon, 고객이름이 NULL을 삽입해보자

```sql

INSERT INTO 고객(고객아이디) VALUES('salmon');
INSERT INTO 고객 VALUES('salmon', NULL);

```

#### ㄴ. 부속 질의문을 이용한 데이터 삽입

- SELECT문을 이용해 다른 테이블에서 검색한 데이터를 삽입

![](/bin/db_image/db_10_15.png)

##### 1) 한빛제과가 만든 제품 정보를 삽입

```sql

INSERT INTO 한빛제품 SELECT 제품명, 재고량, 단가
					FROM 제품
					WHERE 제조업체 = '한빛제과'
;

```

### c. 데이터 수정 (UPDATE)

- 테이블에 저장된 튜플에서 특정 속성의 값을 수정

![](/bin/db_image/db_10_16.png)

- SET 키워드 다음에 속성 값을 어떻게 수정할 것인지를 지정
- WHERE절에 제시된 조건을 만족하는 튜플에 대해서만 속성 값을 수정
	- WHERE 절을 생략하면 테이블에 존재하는 모든 튜플을 대상으로 수정

##### 1) 제품번호가 p03인 제품의 제품명을 통큰파이로 수정

```sql

UPDATE 제품 SET 제품명 = '통큰파이' WHERE 제품번호 = 'p03';

```

### d. 데이터 삭제 (DELETE)

- 테이블에 저장된 데이터를 삭제

![](/bin/db_image/db_10_17.png)

- WHERE절에 제시한 조건을 만족하는 튜플만 삭제
	- WHERE절을 생략하면 테이블에 존재하는 모든 튜플을 삭제해 빈 테이블이 됨

##### 1) 주문 테이블에 존재하는 모든 튜플 삭제

```sql

DELETE FROM 주문;

```

##### 2) 주문 테이블에서 정소화 고객이 주문한 내역을 삭제

```sql

DELETE FROM 주문 WHERE 주문고객 IN (
								SELECT 고객아이디
								FROM 고객
								WHERE 고객이름 = '정소화'
								);

```