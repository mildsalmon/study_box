# 1.1 오라클 DBMS 설치



# 1.2 오라클 DBMS 리스너 확인 

DBMS 도구들은 오라클 DBMS 내에 존재하는 리스터를 통해 오라클 DBMS에 접속하게 된다.

### A. 리스너 상태 확인 방법

관리자 권한으로 Window PowerShell 실행 

```ad-example
title: Window PowerShell

lsnrctl status 

```

화면에 "The command completed successfully" 메시지가 출력되면서 CLRExtProc, PLSExtProc, XEXDB, Xe가 모두 존재하면 리스너 설정이 정상적으로 완료된 것.

만약 위 4개가 없다면, 오라클 삭제 -> 오라클 설치 폴더 삭제 -> PC 재부팅 -> 오라클 DBMS 재설치

# 1.3 SQL\*Plus를 이용한 오라클 DBMS 접속 

### A. 오라클 DBMS에 접속

위 과정을 통해 "로컬 PC에 오라클 DBMS를 설치하였다"고 할 수 있다.

오라클 DBMS는 SQL\*Plus라는 DBMS 도구를 기본적으로 제공한다.

```ad-example
title: Console

cd C:\

```

SQL\*Plus를 이용하여 오라클 DBMS에 SYSDBA권한으로 접속한다.

```ad-todo
title: Console

sqlplus "/as SYSDBA"

```

SYSDBA 권한은 오라클 DBMS에 접속하는 권한 중 치상위 권한이다.

```ad-example
title: SQL

--SQL*Plus 기본 설정
set linesize 200
set timing on
set serveroutput on

```

| 항목         | 설명                                                                                                                                     |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| linesize     | 한 화면에 표시되는 SQL 명령문의 출력 결과에 대한 행의 크기(가로 길이)를 설정한다. 기본값은 80이며, 일반적으로 200으로 지정하여 사용한다. |
| timing       | SQL 명령문을 실행하는 데 소요된 시간을 출력하기 위한 시스템 변수이다.                                                                    |
| serveroutput | PL/SQL문 실행 시 DBMS_OUTPUT.PUT_LINE()으로 로그를 남길 경우, serveroutput 설정을 on으로 지정해야 로그가 정상적으로 출력된다.            |

### B. 오라클 DBMS의 문자 집합 변경

문자 집합을 "UTF-8"에서 "MS949"로 변경하도록 한다.

관리자 권한으로 cmd 실행한다. SQL\*Plus를 이용해서 SYSDBA 계정에 접속한다.

```ad-todo
title: Console

sqlplus "/as SYSDBA"

```

아래 SQL 스크립트를 실행한다.

```ad-example
title: SQL

--시스템 속성 변경 - 문자 집합 속성
UPDATE SYS.PROPS$
   SET VALUE$='KO16MSWIN949'
 WHERE NAME='NLS_CHARACTERSET';
UPDATE SYS.PROPS$
   SET VALUE$='KO16MSWIN949'
 WHERE NAME='NLS_NCHAR_CHARACTERSET';
UPDATE SYS.PROPS$
   SET VALUE$='KOREAN_KOREA.KO16MSWIN949'
 WHERE NAME='NLS_LANGUAGE';
COMMIT;

```

문자 집합에 대한 시스템 속성이 변경되었다.

오라클 DBMS의 실행을 중지시킨다.

```ad-example
title: SQL

--오라클 DBMS 중지
SHUTDOWN IMMEDIATE;

```

아래 명령으로 MOUNT 모드로 다시 오라클 DBMS를 시작한다.

```ad-example
title: SQL

--오라클 DBMS 시작(MOUNT 모드로 시작)
STARTUP MOUNT;

```

아래 SQL 스크립트를 실행한다.

```ad-example
title: SQL

--문자 집합 설정
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;
ALTER SYSTEM SET AQ_TM_PROCESSES=0;
ALTER DATABASE OPEN;
ALTER DATABASE CHARACTER SET KO16MSWIN949;

```

오라클 DBMS의 문자 집합이 "UTF-8"에서 "MS949"로 변경 완료되었다. 이 상태에서 오라클 DBMS를 중지한다.

```ad-example
title: SQL

--오라클 DBMS 시작(MOUNT 모드로 시작)
STARTUP MOUNT;

```

다시 오라클 DBMS를 시작한다.

```ad-example
title: SQL

--오라클 DBMS 시작(MOUNT 모드로 시작)
STARTUP;

```

지금까지의 작업으로 오라클 DBMS의 문자 집합이 "MS949"로 변경되었다.

```ad-info
title: 오라클 DBMS의 문자 집합

--변경된 오라클 DBMS의 문자 집합
KOREAN_KOREA.KO16MSWIN949

```

PC에 사용자 환경 변수 "NLS_LANG"를 추가한다.

"USER에 대한 사용자 변수" -> "NLS_LANG" 변수 -> 값 'KOREAN_KOREA.KO16MSWIN949'로 셋팅한다.

# 1.4 SQL Developer 설치 

[시험장에 몰래 가져갈 이경오의 SQL+SQLD 비밀노트 (hanbit.co.kr)](https://www.hanbit.co.kr/store/books/look.php?p_code=B8289488788)

# 1.5 SQL Developer를 이용한 오라클 DBMS 접속 

# 1.6 DBeaver 설치 

# 1.7 DBeaver를 이용한 오라클 DBMS 접속 