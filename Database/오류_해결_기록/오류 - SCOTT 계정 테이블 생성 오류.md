# 1. 오류 해결 과정

```sql

DESC EMP;

```

![](/Study/image/버그_SCOTT_테이블생성오류_1.png)

???

책에는 PK가 1로 표시되어 있는데, 내 테이블에는 아무것도 없다. 설마 내가 SCOTT 계정을 설정할 때 잘못한게 있었던걸까??

```sql

SELECT * FROM EMP;

```

![](/Study/image/버그_SCOTT_테이블생성오류_2.png)

아무것도 안나온다. (~~사실 이 부분은 버그를 다 수정하고 메모장으로 편집한거다. 어쨋든 고치기 전에는 안나왔으니..~~)

그래서 [꿈꾸는 개발자, DBA 커뮤니티 구루비 (gurubee.net)](http://www.gurubee.net/lecture/2150)를 다시 보면서 SCOTT 스크립트를 실행했다. 에러는 나오는게 없어서 다시 확인을 해보니 위 모습과 달라진게 없었다.

그래서 블로그에 올려진 demobld.sql파일의 SQL문을 하나씩 입력해보기로 했다.

![](/Study/image/버그_SCOTT_테이블생성오류_3.png)

USERS에 대한 권한이 없다는 에러메세지가 나온다.

검색을 해보니 테이블 스페이스에 할당량을 부여하는 권한이 주어져야 insert가 가능하다고 한다. [3]

system 계정에서 아래 명령어를 입력했다.

```sql

alter user scott default tablespace users quota unlimited on users;

```

그리고 INSERT를 입력하니 데이터가 잘 들어갔다.

![](/Study/image/버그_SCOTT_테이블생성오류_4.png)

그래도 테이블을 확인을 해보면 PK부분이 빠져있었다.

![](/Study/image/버그_SCOTT_테이블생성오류_1.png)

그래서 블로그[2]의 SQL문을 다시 확인해봤다. 

![](/Study/image/버그_SCOTT_테이블생성오류_5.png)

테이블을 만들때 애초에 PK를 설정하지 않는구나..

내가 가진 scott.sql 파일을 열어봤다.

![](/Study/image/버그_SCOTT_테이블생성오류_6.png)

REM 부분은 제외하고 scott.sql 파일에 있는 sql문을 한줄씩 입력했다.

![](/Study/image/버그_SCOTT_테이블생성오류_7.png)

이 부분에서 `CONNECT SCOTT/TIGER` 부분이 나와서 SQL PLUS를 하나 더 열어서 나머지 부분을 진행했다. 결과는 성공 !

```sql

DESC EMP;

```

![](/Study/image/버그_SCOTT_테이블생성오류_8.png)

```sql

SELECT *
FROM EMP;

```

![](/Study/image/버그_SCOTT_테이블생성오류_9.png)

# 2. 오류 해결 SQL 파일

위 문제를 해결하는데 사용한 SQL 파일은 아래에 있다.

> system 계정

```sql

GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO SCOTT;
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

```

> scott 계정

```sql

CONNECT SCOTT/TIGER
DROP TABLE DEPT;
CREATE TABLE DEPT
       (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14) ,
	LOC VARCHAR2(13) ) ;
DROP TABLE EMP;
CREATE TABLE EMP
       (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);
INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87')-85,3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-JUL-87')-51,1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
DROP TABLE BONUS;
CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;
DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;

SET TERMOUT ON
SET ECHO ON

```

# 참고문헌

[1] 이지훈, "Do it! 오라클로 배우는 데이터베이스 입문", 초판 5쇄, 이지스퍼블리싱, 2021년

[2] [꿈꾸는 개발자, DBA 커뮤니티 구루비 (gurubee.net)](http://www.gurubee.net/lecture/2150)

[3] [정리킴 - [SQL 오류] ORA-01950 : 테이블스페이스 'USERS'에 대한 권한이 없습니다 (tistory.com)](https://jeongri.tistory.com/128)

#DB #오라클 #doit #doit오라클 #버그