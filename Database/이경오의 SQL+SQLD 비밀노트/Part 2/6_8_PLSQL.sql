DROP TABLE TB_POPLTN_CTPRVN;

--코드 6-91 인구시도 테이블 생성(SQL*Plus에서 실행)
CREATE TABLE TB_POPLTN_CTPRVN
(
  CTPRVN_CD CHAR(2)
, CTPRVN_NM VARCHAR2(50)
, STD_YM CHAR(6)
, POPLTN_SE_CD VARCHAR2(6)
, AGRDE_SE_CD CHAR(3)
, POPLTN_CNT NUMBER(10) NOT NULL
, CONSTRAINT TB_POPLTN_CTPRVN_PK PRIMARY KEY (CTPRVN_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD)
)
;

--코드 6-92 프로시저 생성(SQL*Plus에서 실행)
CREATE OR REPLACE PROCEDURE SP_INSERT_TB_POPLTN_CTPRVN --프로시저명을 선언
(IN_STD_YM IN TB_POPLTN.STD_YM%TYPE) --입력값을 정의
--변수 선언 시작
IS
V_CTPRVN_CD TB_POPLTN_CTPRVN.CTPRVN_CD%TYPE;
V_CTPRVN_NM TB_POPLTN_CTPRVN.CTPRVN_NM%TYPE;
V_STD_YM TB_POPLTN_CTPRVN.STD_YM%TYPE;
V_POPLTN_SE_CD TB_POPLTN_CTPRVN.POPLTN_SE_CD%TYPE;
V_AGRDE_SE_CD TB_POPLTN_CTPRVN.AGRDE_SE_CD%TYPE;
V_POPLTN_CNT TB_POPLTN_CTPRVN.POPLTN_CNT%TYPE;

--변수 선언 종료
--커서 선언 시작
--인구테이블을 시도기준, 기준년월, 인구구분코드,
--연령구분코드별로 인구수합계를 조회
CURSOR SELECT_TB_POPLTN IS
SELECT SUBSTR(A.ADSTRD_CD , 1, 2) AS CTPRVN_CD
     , (SELECT L.ADRES_CL_NM
          FROM TB_ADRES_CL L --주소분류 테이블에서 시도명을 가져옴
         WHERE L.ADRES_CL_CD = SUBSTR(A.ADSTRD_CD , 1, 2)
           AND L.ADRES_CL_SE_CD = 'ACS001' --시도
       ) AS CTPRVN_NM --시도명
     , A.STD_YM
     , A.POPLTN_SE_CD
     , A.AGRDE_SE_CD
     , SUM(A.POPLTN_CNT ) AS POPLTN_CNT
  FROM TB_POPLTN A --인구테이블
 WHERE 1=1
 GROUP BY SUBSTR(A.ADSTRD_CD , 1, 2), A.STD_YM
        , A.POPLTN_SE_CD
        , A.AGRDE_SE_CD
 ORDER BY SUBSTR(A.ADSTRD_CD , 1, 2)
        , A.STD_YM
        , A.POPLTN_SE_CD
        , A.AGRDE_SE_CD
;

--커서 선언 종료
BEGIN --실행부 시작
OPEN SELECT_TB_POPLTN; --커서 열기

--반복문 시작 전 로그출력
DBMS_OUTPUT.PUT_LINE('------------------------------');

LOOP --반복문의 시작

   --커서에서 한 행씩 가져옴
   FETCH SELECT_TB_POPLTN
    INTO
         V_CTPRVN_CD
       , V_CTPRVN_NM
       , V_STD_YM
       , V_POPLTN_SE_CD
       , V_AGRDE_SE_CD
       , V_POPLTN_CNT;

   --더이상 가져올 행이 없으면 반복문을 종료함
   EXIT WHEN SELECT_TB_POPLTN%NOTFOUND;
   --로그출력 시작
   DBMS_OUTPUT.PUT_LINE('V_CTPRVN_CD :'||'['|| V_CTPRVN_CD ||']');
   DBMS_OUTPUT.PUT_LINE('V_CTPRVN_NM :'||'['|| V_CTPRVN_NM ||']');
   DBMS_OUTPUT.PUT_LINE('V_STD_YM :'||'['|| V_STD_YM ||']');
   DBMS_OUTPUT.PUT_LINE('V_POPLTN_SE_CD:'||'['|| V_POPLTN_SE_CD||']');
   DBMS_OUTPUT.PUT_LINE('V_AGRDE_SE_CD :'||'['|| V_AGRDE_SE_CD ||']');
   DBMS_OUTPUT.PUT_LINE('V_POPLTN_CNT :'||'['|| V_POPLTN_CNT ||']');
   --로그출력 종료

   --IF문 시작, 만약 기준년월이 입력년월과 같다면
   IF V_STD_YM = IN_STD_YM THEN

      --TB_POPLTN_CTPRVN 테이블에 INSERT
      INSERT INTO TB_POPLTN_CTPRVN
      VALUES ( V_CTPRVN_CD
             , V_CTPRVN_NM
             , V_STD_YM
             , V_POPLTN_SE_CD
             , V_AGRDE_SE_CD
             , V_POPLTN_CNT
             );

   END IF; --IF문 종료

END LOOP; --반복문의 종료

CLOSE SELECT_TB_POPLTN; --커서 종료

COMMIT; --커밋

--반복문 종료 후 로그출력
DBMS_OUTPUT.PUT_LINE('------------------------------');

END SP_INSERT_TB_POPLTN_CTPRVN; --실행부 종료
/

TRUNCATE TABLE TB_POPLTN_CTPRVN;
SET SERVEROUTPUT ON;
EXECUTE SP_INSERT_TB_POPLTN_CTPRVN('202010');

SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
 ORDER BY CTPRVN_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD
;

CREATE OR REPLACE FUNCTION F_GET_TK_GFF_CNT --사용자 정의 함수 선언
(
  IN_SUBWAY_STATN_NO IN TB_SUBWAY_STATN.SUBWAY_STATN_NO%TYPE --입력값 선언
, IN_STD_YM IN TB_SUBWAY_STATN_TK_GFF.STD_YM %TYPE --입력값 선언
)
RETURN NUMBER IS V_TK_GFF_CNT NUMBER; --리턴값 선언

BEGIN
    SELECT SUM(A.TK_GFF_CNT) AS TK_GFF_CNT
      INTO V_TK_GFF_CNT
      FROM TB_SUBWAY_STATN_TK_GFF A --지하철역승하차
     WHERE A.SUBWAY_STATN_NO = IN_SUBWAY_STATN_NO --지하철역번호
       AND A.STD_YM = IN_STD_YM --기준년월
    ;

    RETURN V_TK_GFF_CNT;
END;
/

SELECT *
  FROM
     (
       SELECT A.SUBWAY_STATN_NO, A.LN_NM, A.STATN_NM
            , F_GET_TK_GFF_CNT(A.SUBWAY_STATN_NO, '202010') AS TK_GFF_CNT
         FROM TB_SUBWAY_STATN A
        WHERE 1=1
          AND A.LN_NM = '9호선'
        ORDER BY TK_GFF_CNT DESC
     )
 WHERE ROWNUM <= 10
;

CREATE OR REPLACE TRIGGER TRIG_TB_POPLTN_CTPRVN_INSERT --트리거명 선언
AFTER INSERT --입력 후에 이 트리거가 실행
ON TB_POPLTN --인구 테이블에 입력 후에
FOR EACH ROW --각각의 행을 입력 후에
DECLARE

--변수 선언 시작
--V_ADSTRD_CD 변수의 데이터형은
--TB_POPLTN 테이블의 ADSTRD_CD 칼럼의 데이터형으로 지정
V_ADSTRD_CD TB_POPLTN.ADSTRD_CD%TYPE;
V_STD_YM TB_POPLTN.STD_YM%TYPE;
V_POPLTN_SE_CD TB_POPLTN.POPLTN_SE_CD%TYPE;
V_AGRDE_SE_CD TB_POPLTN.AGRDE_SE_CD%TYPE;
--변수 선언 종료

BEGIN --로직 시작
V_ADSTRD_CD := :NEW.ADSTRD_CD; --TB_POPLTN에 INSERT된 ADSTRD_CD 값
V_STD_YM := :NEW.STD_YM; --TB_POPLTN에 INSERT된 STD_MT 값
V_POPLTN_SE_CD := :NEW.POPLTN_SE_CD; --TB_POPLTN에 INSERT된 POPLTN_SE_CD 값
V_AGRDE_SE_CD := :NEW.AGRDE_SE_CD; ----TB_POPLTN에 INSERT된 AGRDE_SE_CD 값

--TB_POPLTN_CTPRVN 테이블에 인구수를 누적 업데이트함
UPDATE TB_POPLTN_CTPRVN A
   SET A.POPLTN_CNT = A.POPLTN_CNT + :NEW.POPLTN_CNT
 WHERE A.CTPRVN_CD = SUBSTR(V_ADSTRD_CD, 1, 2)
   AND A.STD_YM = V_STD_YM
   AND A.POPLTN_SE_CD = V_POPLTN_SE_CD
   AND A.AGRDE_SE_CD = V_AGRDE_SE_CD
;

--TB_POPLTN_CTPRVN 테이블에 해당 행이 없다면 신규로 INSERT함
IF SQL%NOTFOUND THEN
   INSERT INTO
          TB_POPLTN_CTPRVN (
                             CTPRVN_CD
                           , CTPRVN_NM
                           , STD_YM
                           , POPLTN_SE_CD
                           , AGRDE_SE_CD
                           , POPLTN_CNT
                           )
                    VALUES (
                             SUBSTR(V_ADSTRD_CD, 1, 2)
                             --주소분류 테이블에서 시도명을 가져옴
                             , (SELECT L.ADRES_CL_NM
                                  FROM TB_ADRES_CL L
                                 WHERE L.ADRES_CL_CD = SUBSTR(V_ADSTRD_CD, 1, 2)
                                   AND L.ADRES_CL_SE_CD = 'ACS001' --시도
                               )
                             , V_STD_YM
                             , V_POPLTN_SE_CD
                             , V_AGRDE_SE_CD
                             , :NEW.POPLTN_CNT
                           );
END IF;

END;
/

--코드 6-98 트리거 호출(SQL*Plus에서 실행)
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
               VALUES ( '4128157500' --경기도 고양시 삼송동
                      , '202009' --2020년 09월 기준
                      , 'F' --여성
                      , '030' --30대
                      , 2000 --2000명
                      );
                      

--코드 6-99 트리거 실행 결과 확인(SQL*Plus에서 실행)
SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
 WHERE CTPRVN_CD = '41'
   AND STD_YM = '202009'
;

ROLLBACK;

SELECT *
FROM TB_POPLTN
WHERE ADSTRD_CD = '4128157500'
    AND AGRDE_SE_CD = '030';

--코드 6-101 트리거 실행 취소 확인(SQL*Plus에서 실행)
SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
  WHERE CTPRVN_CD = '41'
   AND STD_YM = '202009'
;

--코드 6-102 트리거 실행 및 완전 적용(SQL*Plus에서 실행)
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
     VALUES ( '4128157500' --경기도 고양시 삼송동
            , '202008' --2020년 09월 기준
            , 'F' --여성
            , '030' --30대
            , 2000 --2000명
            )
;

COMMIT;

--코드 6-103 트리거 적용 결과 확인(SQL*Plus에서 실행)
SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
  WHERE CTPRVN_CD = '41'
    AND STD_YM = '202008'
;

SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
;

--코드 6-104 트리거 실행 및 완전 적용(SQL*Plus에서 실행)
INSERT INTO TB_POPLTN (ADSTRD_CD, STD_YM, POPLTN_SE_CD, AGRDE_SE_CD, POPLTN_CNT)
               VALUES ( '4128158000' --경기도 고양시 덕양구 창릉동
                      , '202008' --2020년 09월 기준
                      , 'F' --여성
                      , '030' --30대
                      , 2100 --2100명
                      )
;

COMMIT;

SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TB_POPLTN';

--코드 6-105 트리거 실행 확인(SQL*Plus에서 실행)
SELECT CTPRVN_CD
     , CTPRVN_NM
     , STD_YM
     , POPLTN_SE_CD
     , AGRDE_SE_CD
     , POPLTN_CNT
  FROM TB_POPLTN_CTPRVN
  WHERE CTPRVN_CD = '41'
   AND STD_YM = '202008'
;