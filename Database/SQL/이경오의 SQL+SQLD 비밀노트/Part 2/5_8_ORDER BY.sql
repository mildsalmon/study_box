SELECT A.INDUTY_CL_CD
            , A.INDUTY_CL_NM
            , A.INDUTY_CL_SE_CD
            , NVL(A.UPPER_INDUTY_CL_CD, '(Null)') AS UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_SE_CD = 'ICS001'
ORDER BY A.INDUTY_CL_CD
;

SELECT A.INDUTY_CL_CD
            , A.INDUTY_CL_NM
            , A.INDUTY_CL_SE_CD
            , NVL(A.UPPER_INDUTY_CL_CD, '(Null)') AS UPPER_INDUTY_CL_CD
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_SE_CD = 'ICS001'
ORDER BY A.INDUTY_CL_CD DESC
;

SELECT A.INDUTY_CL_CD AS "업종분류코드"
            , A.INDUTY_CL_NM AS "업종분류명"
            , A.INDUTY_CL_SE_CD AS "업종분류구분코드"
            , NVL(A.UPPER_INDUTY_CL_CD, '(Null)') AS "상위업종분류코드"
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_CD LIKE 'Q%'
     AND A.INDUTY_CL_NM LIKE '%음식%'
ORDER BY A.UPPER_INDUTY_CL_CD DESC
;

-- ORDER BY에서 -1은 동작 안함.

SELECT A.INDUTY_CL_CD AS "업종분류코드"
            , A.INDUTY_CL_NM AS "업종분류명"
            , A.INDUTY_CL_SE_CD AS "업종분류구분코드"
            , NVL(A.UPPER_INDUTY_CL_CD, '(Null)') AS "상위업종분류코드"
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_CD LIKE 'Q%'
     AND A.INDUTY_CL_NM LIKE '%음식%'
ORDER BY -1
;

SELECT A.SUBWAY_STATN_NO
            , A.LN_NM
FROM TB_SUBWAY_STATN A
WHERE A.LN_NM = '9호선'
ORDER BY A.STATN_NM
;

SELECT A.SUBWAY_STATN_NO
            , A.LN_NM
            , A.STATN_NM
FROM TB_SUBWAY_STATN A
WHERE A.LN_NM = '9호선'
ORDER BY A.STATN_NM
;

SELECT A.AGRDE_SE_CD
            , SUM(A.POPLTN_CNT) AS SUM_POPLTN_CNT
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
    AND A.POPLTN_SE_CD IN ('M', 'F')
GROUP BY A.AGRDE_SE_CD
ORDER BY SUM(A.POPLTN_CNT) DESC
;

SELECT A.AGRDE_SE_CD
            , SUM(A.POPLTN_CNT) AS SUM_POPLTN_CNT
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
    AND A.POPLTN_SE_CD IN ('M', 'F')
GROUP BY A.AGRDE_SE_CD
ORDER BY A.POPLTN_SE_CD DESC
;

SELECT A.BSSH_NO
            , A.CMPNM_NM
            , A.BHF_NM
            , A.LNM_ADRES
            , A.LO
            , A.LA
FROM TB_BSSH A
WHERE ROWNUM <= 10
ORDER BY A.LO
;

SELECT A.BSSH_NO
            , A.CMPNM_NM
            , A.BHF_NM
            , A.LNM_ADRES
            , A.LO
            , A.LA
FROM
    (
        SELECT A.BSSH_NO
                    , A.CMPNM_NM
                    , A.BHF_NM
                    , A.LNM_ADRES
                    , A.LO
                    , A.LA
            FROM    TB_BSSH A
            ORDER BY A.LO
    ) A
WHERE ROWNUM <= 10
;

