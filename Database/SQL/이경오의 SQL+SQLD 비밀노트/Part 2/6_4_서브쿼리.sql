SELECT A.TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.SUBWAY_STATN_NO = '000615'
    AND A.STD_YM = '202010'
    AND A.BEGIN_TIME = '0800'
    AND A.END_TIME = '0900'
    AND A.TK_GFF_SE_CD = 'TGS002'
;

SELECT A.TK_GFF_CNT, A.SUBWAY_STATN_NO, B.LN_NM, B.STATN_NM
FROM TB_SUBWAY_STATN_TK_GFF A
        , TB_SUBWAY_STATN B
WHERE A.STD_YM = '202010'
        AND A.BEGIN_TIME = '0800'
        AND A.END_TIME = '0900'
        AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
        AND TK_GFF_SE_CD = 'TGS002'
        AND TK_GFF_CNT > (
                                            SELECT A.TK_GFF_CNT
                                            FROM TB_SUBWAY_STATN_TK_GFF A
                                            WHERE A.SUBWAY_STATN_NO = '000615'
                                                AND A.STD_YM = '202010'
                                                AND A.BEGIN_TIME = '0800'
                                                AND A.END_TIME = '0900'
                                                AND A.TK_GFF_SE_CD = 'TGS002'
                                        )
ORDER BY A.TK_GFF_CNT DESC;                                        

SELECT K.SUBWAY_STATN_NO
FROM TB_SUBWAY_STATN_TK_GFF K
WHERE K.STD_YM = '202010'
    AND K.BEGIN_TIME = '0800'
    AND K.END_TIME = '0900'
    AND K.TK_GFF_SE_CD = 'TGS002'
    AND K.TK_GFF_CNT >= 250000
;

SELECT B.SUBWAY_STATN_NO
        , B.LN_NM
        , B.STATN_NM
FROM TB_SUBWAY_STATN B
WHERE B.SUBWAY_STATN_NO IN (
                                                        SELECT K.SUBWAY_STATN_NO
                                                        FROM TB_SUBWAY_STATN_TK_GFF K
                                                        WHERE K.STD_YM = '202010'
                                                            AND K.BEGIN_TIME = '0800'
                                                            AND K.END_TIME = '0900'
                                                            AND K.TK_GFF_SE_CD = 'TGS002'
                                                            AND K.TK_GFF_CNT >= 250000
                                                   )
ORDER BY B.SUBWAY_STATN_NO                                                   
;

SELECT K.AGRDE_SE_CD
            , MAX(K.POPLTN_CNT) AS POPLTN_CNT
FROM TB_POPLTN K
WHERE K.STD_YM = '202010'
    AND K.POPLTN_SE_CD = 'T'
GROUP BY K.AGRDE_SE_CD
ORDER BY POPLTN_CNT DESC
;

SELECT A.ADSTRD_CD
        , B.ADSTRD_NM
        , A.STD_YM
        , A.POPLTN_SE_CD
        , A.AGRDE_SE_CD
        , A.POPLTN_CNT
FROM TB_POPLTN A
        , TB_ADSTRD B
WHERE A.STD_YM = '202010'
        AND A.POPLTN_SE_CD = 'T'
        AND (A.AGRDE_SE_CD, A.POPLTN_CNT)
            IN (
                    SELECT K.AGRDE_SE_CD
                        , MAX(K.POPLTN_CNT) AS POPLTN_CNT
                    FROM TB_POPLTN K
                    WHERE K.STD_YM = '202010'
                        AND K.POPLTN_SE_CD = 'T'
                    GROUP BY K.AGRDE_SE_CD
                )
        AND A.ADSTRD_CD = B.ADSTRD_CD 
ORDER BY A.AGRDE_SE_CD
;

SELECT A.SUBWAY_STATN_NO
            , A.LN_NM
            , A.STATN_NM
FROM TB_SUBWAY_STATN A
WHERE EXISTS (
                            SELECT 1
                            FROM TB_SUBWAY_STATN_TK_GFF K
                            WHERE K.SUBWAY_STATN_NO = A.SUBWAY_STATN_NO
                                AND K.STD_YM = '202010'
                                AND TK_GFF_CNT >= 250000
                        )
ORDER BY A.SUBWAY_STATN_NO  
;

SELECT A.SUBWAY_STATN_NO
            , A.LN_NM
            , A.STATN_NM
FROM TB_SUBWAY_STATN A
WHERE NOT EXISTS (
                            SELECT 1
                            FROM TB_SUBWAY_STATN_TK_GFF K
                            WHERE K.SUBWAY_STATN_NO = A.SUBWAY_STATN_NO
                                AND K.STD_YM = '202010'
                                AND TK_GFF_CNT >= 250000
                        )
ORDER BY A.SUBWAY_STATN_NO  
;

SELECT A.ADSTRD_CD
        , (SELECT L.ADSTRD_NM
            FROM TB_ADSTRD L
            WHERE L.ADSTRD_CD = A.ADSTRD_CD) AS ADSTRD_NM
        , A.STD_YM
        , A.POPLTN_SE_CD
        , A.AGRDE_SE_CD
        , A.POPLTN_CNT
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
    AND A.POPLTN_SE_CD = 'T'
    AND (A.AGRDE_SE_CD, A.POPLTN_CNT)
        IN (
                SELECT K.AGRDE_SE_CD
                        , MAX(K.POPLTN_CNT) AS POPLTN_CNT
                FROM TB_POPLTN K
                WHERE K.STD_YM = '202010'
                    AND K.POPLTN_SE_CD = 'T'
                GROUP BY K.AGRDE_SE_CD
            )
ORDER BY A.AGRDE_SE_CD
;

SELECT A.SUBWAY_STATN_NO
        , A.STD_YM
        , A.BEGIN_TIME
        , A.END_TIME
        , A.TK_GFF_SE_CD
        , A.TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.STD_YM = '202010'
    AND A.BEGIN_TIME = '1800'
    AND A.END_TIME = '1900'
    AND A.TK_GFF_SE_CD = 'TGS002'
    AND A.TK_GFF_CNT > 150000
ORDER BY A.TK_GFF_CNT DESC
;

SELECT B.SUBWAY_STATN_NO
        , B.LN_NM
        , B.STATN_NM
        , A.STD_YM
        , A.BEGIN_TIME
        , A.END_TIME
        , A.TK_GFF_SE_CD
        , A.TK_GFF_CNT
FROM (
                SELECT A.SUBWAY_STATN_NO
                        , A.STD_YM
                        , A.BEGIN_TIME
                        , A.END_TIME
                        , A.TK_GFF_SE_CD
                        , A.TK_GFF_CNT
                FROM TB_SUBWAY_STATN_TK_GFF A
                WHERE A.STD_YM = '202010'
                    AND A.BEGIN_TIME = '1800'
                    AND A.END_TIME = '1900'
                    AND A.TK_GFF_SE_CD = 'TGS002'
                    AND A.TK_GFF_CNT > 150000
            ) A
            , TB_SUBWAY_STATN B
WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
ORDER BY A.TK_GFF_CNT DESC
;

SELECT ROUND(AVG(A.TK_GFF_CNT), 2) AS AVG_TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.STD_YM = '202010'
    AND A.BEGIN_TIME = '1800'
    AND A.END_TIME = '1900'
    AND A.TK_GFF_SE_CD = 'TGS002'
;

SELECT A.SUBWAY_STATN_NO
        , (SELECT L.STATN_NM || '(' || L.LN_NM || ')'
            FROM TB_SUBWAY_STATN L
            WHERE L.SUBWAY_STATN_NO = A.SUBWAY_STATN_NO
            ) AS STATN_INFO
        , ROUND(MAX(A.TK_GFF_CNT), 2) AS TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.STD_YM = '202010'
    AND A.BEGIN_TIME = '1800'
    AND A.END_TIME = '1900'
    AND A.TK_GFF_SE_CD = 'TGS002'
    GROUP BY A.SUBWAY_STATN_NO
    HAVING ROUND(MAX(A.TK_GFF_CNT), 2) > (
                                                                        SELECT ROUND(AVG(A.TK_GFF_CNT), 2) AS AVG_TK_GFF_CNT
                                                                        FROM TB_SUBWAY_STATN_TK_GFF A
                                                                        WHERE A.STD_YM = '202010'
                                                                            AND A.BEGIN_TIME = '1800'
                                                                            AND A.END_TIME = '1900'
                                                                            AND A.TK_GFF_SE_CD = 'TGS002'
                                                                    )
ORDER BY TK_GFF_CNT DESC
;

ALTER TABLE TB_POPLTN ADD(ADSTRD_NM VARCHAR2(150));

UPDATE TB_POPLTN A
    SET A.ADSTRD_NM = (
                                        SELECT K.ADSTRD_NM
                                        FROM TB_ADSTRD K
                                        WHERE K.ADSTRD_CD = A.ADSTRD_CD
                                    )
;

COMMIT;

SELECT A.ADSTRD_CD
        , A.STD_YM
        , A.POPLTN_SE_CD
        , A.AGRDE_SE_CD
        , A.POPLTN_CNT
        , A.ADSTRD_NM
FROM TB_POPLTN A
WHERE ROWNUM <= 10
;

CREATE TABLE TB_SUBWAY_STATN_TK_GFF_SUM
(
    SUBWAY_STATN_NO CHAR(6)
    , TK_GFF_CNT NUMBER(15)
    , CONSTRAINT TB_SUBWAY_STATN_TK_GFF_SUM_PK PRIMARY KEY(SUBWAY_STATN_NO)
);

INSERT INTO TB_SUBWAY_STATN_TK_GFF_SUM
VALUES ('000615', (
                                SELECT SUM(TK_GFF_CNT)
                                FROM TB_SUBWAY_STATN_TK_GFF
                                WHERE SUBWAY_STATN_NO = '000615'
                            )
                );
COMMIT;

SELECT *
FROM TB_SUBWAY_STATN_TK_GFF_SUM;

DROP TABLE TB_SUBWAY_STATN_TK_GFF_SUM PURGE;

CREATE OR REPLACE VIEW V_STARBUCKS_POPLTN_INFO
AS
SELECT A.BSSH_NO
        , A.CMPNM_NM
        , A.BHF_NM
        , A.ADSTRD_CD
        , B.ADSTRD_NM
        , SUM(C.POPLTN_CNT) AS SUM_POPLTN_CNT
FROM TB_BSSH A
    , TB_ADSTRD B
    , TB_POPLTN C
WHERE (CMPNM_NM LIKE '%스타벅스%'
                OR
                UPPER(CMPNM_NM) LIKE '%STARBUCKS%'
            )
    AND A.ADSTRD_CD = B.ADSTRD_CD
    AND B.ADSTRD_CD = C.ADSTRD_CD
    AND C.STD_YM = '202010'
    AND C.POPLTN_SE_CD = 'T'
GROUP BY A.BSSH_NO, A.CMPNM_NM, A.BHF_NM, A.ADSTRD_CD, B.ADSTRD_NM
ORDER BY A.BSSH_NO, A.CMPNM_NM, A.BHF_NM, A.ADSTRD_CD, B.ADSTRD_NM
;

SELECT A.BSSH_NO
        , A.CMPNM_NM
        , A.BHF_NM
        , A.ADSTRD_CD
        , A.ADSTRD_NM
        , A.SUM_POPLTN_CNT
FROM V_STARBUCKS_POPLTN_INFO A
;

SELECT A.BSSH_NO
        , A.CMPNM_NM
        , A.BHF_NM
        , A.ADSTRD_CD
        , A.ADSTRD_NM
        , A.SUM_POPLTN_CNT
FROM V_STARBUCKS_POPLTN_INFO A
WHERE ADSTRD_NM LIKE '%경기도%고양시%'
;

DROP VIEW V_STARBUCKS_POPLTN_INFO;

