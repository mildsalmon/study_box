# 2.1 사용자 계정 및 테이블 스페이스 생성 

### A. 사용자 계정 생성

```ad-example
title: SQL

--코드 2-1 사용자 계정 생성 - SYSTEM 계정으로 로그인하여 실행
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER SQLD IDENTIFIED BY 1234; --사용자 계정 생성
ALTER USER SQLD ACCOUNT UNLOCK; --생성한 사용자 계정의 잠금 해제
GRANT RESOURCE, DBA, CONNECT TO SQLD; --생성한 사용자 계정에게 권한 부여

```

관리자 권한의 계정인 SYSTEM 계정으로 접속하여 

사용자 계정인 "SQLD" 계정을 생성하고, 비밀번호는 '1234'로 설정한다.  
SQLD 계정의 계정 잠금을 해제한다.  
이 계정에게 "RESOURCE", "DBA", "CONNECT" 권한을 준다.

이렇게 하면 SQLD 계정은 DBA(Database Administrator)의 권한을 가지게 된다.

### B. 테이블 스페이스 및 임시 테이블 스페이스 설정

테이블 스페이스 및 임시 테이블 스페이스를 생성한다.

```ad-example
title: SQL

--코드 2-2 테이블 스페이스 및 임시 테이블 스페이스 생성 - SYSTEM 계정으로 로그인하여 실행
CREATE TABLESPACE SQLD_DATA
DATAFILE 'C:\app\mildsalmon\product\18.0.0\oradata\XE\SQLD_DATA.dbf' SIZE 4G
AUTOEXTEND ON NEXT 512M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TEMPORARY TABLESPACE SQLD_TEMP
TEMPFILE 'C:\app\mildsalmon\product\18.0.0\oradata\XE\SQLD_TEMP.dbf' SIZE 1G
AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;

```

생성한 테이블 스페이스를 SQLD 계정의 디폴트 테이블 스페이스로 지정한다.

```ad-example
title: SQL

--코드 2-3 디폴트 및 임시 테이블 스페이스 지정 - SYSTEM 계정으로 로그인하여 실행
ALTER USER SQLD DEFAULT TABLESPACE SQLD_DATA;
ALTER USER SQLD TEMPORARY TABLESPACE SQLD_TEMP;

```

위 설정으로 SQLD 계정으로 접속하여 생성하는 테이블은 지정한 디폴트 테이블 스페이스인 "SQLD_DATA"내에 생성되고 SQLD 계정이 SQL 작업을 할 때는 지정한 임시(TEMPORARY) 테이블 스페이스인 "SQLD_TEMP"의 저장공간을 이용하게 된다.

# 2.2 실습 데이터 모델 소개 

### A. 상가 데이터

소상공인시장진흥공단에서는 전국의 상가/업소 데이터인 상가 데이터를 제공한다. 상가 데이터는 공공 데이터포털 사이트에서 다운로드할 수 있다.

상가 데이터는 전국에 존재하는 상가/업소에 대한 데이터이다. 이 데이터는 상점명, 지점명, 주소(위도/경도), 업종코드 등의 항목으로 이루어져 있으며 상권 분석을 하는 데 매우 유용하다.

```ad-info
title: 상가 데이터

[소상공인시장진흥공단_상가(상권)정보_20210630 | 공공데이터포털 (data.go.kr)](https://www.data.go.kr/data/15083033/fileData.do)

```

### B. 지하철역승하차 데이터

한국스마트카드에서는 지하철역승하차 데이터를 제공한다. 이 데이터에는 지하철역의 시간대별 승하차인원수 데이터가 있다.

```ad-info
title: 지하철역 승하차 데이터

[대중교통통계자료 - 이용안내 - 티머니 (tmoney.co.kr)](https://pay.tmoney.co.kr/ncs/pct/ugd/ReadTrcrStstList.dev)

```


### C. 인구 데이터

행정안전부에서는 전국의 읍/면/동별, 성별, 연령별 인구수 데이터를 제공한다.

```ad-info
title: 주민등록 인구통계

[주민등록 인구통계 행정안전부 (mois.go.kr)](https://jumin.mois.go.kr/index.jsp)

```

인구 데이터는 상가 데이터와 결합하여 상권 분석을 하는 데 유용한 데이터로 이용된다.

### D. 데이터 모델 설계

![](/bin/db_image/SQLD_2_1.png)

네모는 엔티티를 의미한다. 엔티티는 엑셀에서 정리하는 표라고 생각하면 된다.

논리 데이터 모델링을 통해서 위 그림과 같은 논리 데이터 모델이 도출되었다.

도출된 논리 데이터 모델에 기반하여 물리 데이터 모델링 작업을 한다. 물리 데이터 모델링을 통해서 물리 데이터 모델이 도출된다. 물리 데이터 모델에서는 엔티티를 테이블이라고 부른다.

# 2.3 테이블 생성 및 데이터 입력 

실습환경 구축 과정

| 순번 | 과정                  | 설명                                                                                                  |
| ---- | --------------------- | ----------------------------------------------------------------------------------------------------- |
| 1    | 임시 테이블 생성      | 오라클 DBMS의 SQLD 계정에 원천 데이터 저장을 위한 임시 테이블을 생성한다.                             |
| 2    | 원천 데이터 저장      | 원천 데이터 파일을 읽어서 원천 테이블에 원천 데이터를 저장한다.                                       |
| 3    | 테이블 생성           | SQLD 계정에 실습 데이터 모델과 동일하게 테이블을 생성한다.                                            |
| 4    | 데이터 저장           | 원천 테이블의 데이터를 실습 데이터 모델에 맞게 가공하여 저장한다.                                     |
| 5    | 오라클 덤프 파일 생성 | SQLD 계정에 있는 테이블 및 데이터를 Oracle Data Pump 유틸리티를 이용하여 오라클 덤프 파일로 생성한다. |

오라클 덤프 파일만 자신의 PC에 적용하면 실습 데이터 환경 구축이 완료된다.

윈도우 cmd를 관리자 권한으로 실행한다.

```ad-todo
title: Console

sqlplus "/as SYSDBA"

```

'C:\\'로 이동한 후 "SQLD" 폴더를 생성하고 생성한 폴더로 이동한다.

```ad-todo
title: Console

--폴더 생성
cd c:\
md SQLD
cd SQLD

```

SQL\*Plus를 이용하여 SYSDBA 권한으로 오라클 DBMS에 접속한다.

```ad-todo
title: Console

--SYSDBA 권한으로 오라클 DBMS 접속
sqlplus "/as SYSDBA"

```

아래 SQL 스크립트를 실행한다.

윈도우의 특정 폴더와 오라클 DBMS 간의 통신을 위해 사용될 오라클 디렉터리를 생성하고,

해당 디렉터리에 실행, 쓰기, 읽기 권한을 준다.

```ad-example
title: SQL

--코드 2-4 오라클 디렉터리 생성
CREATE OR REPLACE DIRECTORY D_SQLD AS 'C:\SQLD';
GRANT EXECUTE ON DIRECTORY D_SQLD TO SQLD WITH GRANT OPTION;
GRANT WRITE ON DIRECTORY D_SQLD TO SQLD WITH GRANT OPTION;
GRANT READ ON DIRECTORY D_SQLD TO SQLD WITH GRANT OPTION;

```

오라클 DBMS(SQL\*Plus) 접속을 해제한다.

```ad-example
title: SQL

quit

```

아래 주소에서 덤프 파일을 다운로드한다.

```ad-info
title: 한빛미디어

[시험장에 몰래 가져갈 이경오의 SQL+SQLD 비밀노트 (hanbit.co.kr)](https://www.hanbit.co.kr/store/books/look.php?p_code=B8289488788)

```

"EXPORT_SQLD.dump" 파일을 "C:\\SQLP" 폴더에 저장한 후 cmd 프로그램을 관리자 권한으로 실행한다.

```ad-todo
title: Console

--impdp 명령을 이용하여 오라클 덤프 파일을 오라클 DBMS에 적용(임포트)
impdp SQLD/1234 schemas=SQLD directory=D_SQLD dumpfile=EXPORT_SQLD.dmp logfile=EXPORT_SQLD.log

```

위 명령어를 실행하여 오라클 덤프 파일을 자신의 PC에 적용한다.

PC에 설치한 오라클 DBMS 내에 존재하는 SQLD 계정에 테이블을 생성하고, 생성한 테이블에 데이터를 적재(입력)하는 것이다.

SQL Developer로 SQL문을 실행하자.

```ad-example
title: SQL

--코드 2-5 실습 데이터 구성 확인
SELECT ROWNUM AS 순번
     , TABLE_NAME AS 테이블명
     , (SELECT L.COMMENTS
          FROM DBA_TAB_COMMENTS L
         WHERE L.OWNER = 'SQLD'
           AND L.TABLE_NAME = A.TABLE_NAME) AS 테이블한글명
     , DATA_CNT AS 테이블행수
     , COUNT(*) OVER() AS 총테이블수
     , SUM(DATA_CNT) OVER() AS 총행수
  FROM
     (
       SELECT TRIM('TB_ADRES_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADRES_CL
       UNION ALL
       SELECT TRIM('TB_ADRES_CL_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADRES_CL_SE
       UNION ALL
       SELECT TRIM('TB_ADSTRD') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADSTRD
       UNION ALL
       SELECT TRIM('TB_AGRDE_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_AGRDE_SE
       UNION ALL
       SELECT TRIM('TB_PLOT_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_PLOT_SE
       UNION ALL
       SELECT TRIM('TB_POPLTN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_POPLTN
       UNION ALL
       SELECT TRIM('TB_POPLTN_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_POPLTN_SE
       UNION ALL
       SELECT TRIM('TB_RN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_RN
       UNION ALL
       SELECT TRIM('TB_STDR_INDUST_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_STDR_INDUST_CL
       UNION ALL
       SELECT TRIM('TB_SUBWAY_STATN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_SUBWAY_STATN
       UNION ALL
       SELECT TRIM('TB_SUBWAY_STATN_TK_GFF') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_SUBWAY_STATN_TK_GFF
       UNION ALL
       SELECT TRIM('TB_TK_GFF_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_TK_GFF_SE
       UNION ALL
       SELECT TRIM('TB_BSSH') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_BSSH
       UNION ALL
       SELECT TRIM('TB_INDUTY_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_INDUTY_CL
       UNION ALL
       SELECT TRIM('TB_INDUTY_CL_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_INDUTY_CL_SE
     ) A
;

```

테이블의 총 개수는 15개이며 모든 테이블에 존재하는 데이터 행은 총 2,849,846건이다.

### A. impdp 작업에 실패했다면

SQL 스크립트를 실행시켜서 SQL 실습환경을 구축하자.

### B. 오라클 DBMS 실습환경을 재구성하고 싶은 경우

SQL 스크립트를 실행한 후 다시 테이블 생성 및 데이터 입력을 하면 된다.

```ad-example
title: SQL

--SQL*Plus로 SQLD 계정으로 접속
DROP TABLE TB_BSSH PURGE;
DROP TABLE TB_ADRES_CL PURGE;
DROP TABLE TB_ADRES_CL_SE PURGE;
DROP TABLE TB_RN PURGE;
DROP TABLE TB_STDR_INDUST_CL PURGE;
DROP TABLE TB_INDUTY_CL PURGE;
DROP TABLE TB_INDUTY_CL_SE PURGE;
DROP TABLE TB_PLOT_SE PURGE;
DROP TABLE TB_POPLTN PURGE;
DROP TABLE TB_AGRDE_SE PURGE;
DROP TABLE TB_POPLTN_SE PURGE;
DROP TABLE TB_ADSTRD PURGE;
DROP TABLE TB_SUBWAY_STATN_TK_GFF PURGE;
DROP TABLE TB_SUBWAY_STATN PURGE;
DROP TABLE TB_TK_GFF_SE PURGE;

```


# 2.4 SQL 실습환경 구축 과정 소개 

"실습환경구축.zip"의 모든 내용은 이 책의 모든 과정을 학습 완료한 후 보는 것을 추천한다.