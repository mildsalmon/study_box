SELECT *
FROM (
            SELECT A.ADSTRD_CD
                        , B.ADSTRD_NM
                        , A.STD_YM
                        , A.POPLTN_SE_CD
                        , A.AGRDE_SE_CD
                        , A.POPLTN_CNT
                        , RANK() OVER(ORDER BY A.POPLTN_CNT DESC) AS RANK
                        , DENSE_RANK() OVER(ORDER BY A.POPLTN_CNT DESC) AS DENSE_RANK
                        , ROW_NUMBER() OVER(ORDER BY A.POPLTN_CNT DESC) AS ROW_NUMBER
            FROM TB_POPLTN A
                    , TB_ADSTRD B
            WHERE A.AGRDE_SE_CD = '100'
                    AND A.STD_YM = '202010'
                    AND A.POPLTN_SE_CD = 'F'
                    AND A.ADSTRD_CD = B.ADSTRD_CD
            ORDER BY A.POPLTN_CNT DESC
            )
WHERE ROWNUM <= 10
;

SELECT A.ADSTRD_CD
        , A.ADSTRD_NM
        , A.AGRDE_SE_CD
        , A.POPLTN_CNT
        , MAX(A.POPLTN_CNT) OVER(PARTITION BY A.AGRDE_SE_CD) AS 최대_인구수
        , MIN(A.POPLTN_CNT) OVER(PARTITION BY A.AGRDE_SE_CD) AS 최소_인구수
        , ROUND(AVG(A.POPLTN_CNT) OVER(PARTITION BY A.AGRDE_SE_CD), 2) AS 평균_인구수
        , ROUND(AVG(A.POPLTN_CNT) OVER(PARTITION BY A.AGRDE_SE_CD
                                                                ORDER BY A.POPLTN_CNT ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS 평균_인구수_1_1
FROM (
            SELECT A.ADSTRD_CD
                    , B.ADSTRD_NM AS ADSTRD_NM
                    , A.AGRDE_SE_CD
                    , A.POPLTN_CNT
                    FROM TB_POPLTN A, TB_ADSTRD B
                    WHERE A.POPLTN_SE_CD = 'T'
                        AND A.STD_YM = '202010'
                        AND A.ADSTRD_CD = B.ADSTRD_CD
                        AND A.POPLTN_CNT > 0
                        AND B.ADSTRD_NM LIKE '경기도%고양시%덕양구%'
            ) A
;            

SELECT A.ADSTRD_CD
        , A.ADSTRD_NM
        , A.AGRDE_SE_CD
        , A.POPLTN_CNT
        , COUNT(*) OVER() 총결과행수
        , COUNT(*) OVER(PARTITION BY A.ADSTRD_CD) AS 행정동별행수
        , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD) AS SUM_1
        , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
                                                        ORDER BY A.POPLTN_CNT RANGE UNBOUNDED PRECEDING) AS SUM_2
        , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
                                                        ORDER BY A.POPLTN_CNT ROWS UNBOUNDED PRECEDING) AS SUM_3
        , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
                                                        ORDER BY A.POPLTN_CNT RANGE BETWEEN UNBOUNDED PRECEDING
                                                                                                                    AND UNBOUNDED FOLLOWING) AS SUM_4
FROM (
            SELECT A.ADSTRD_CD
                    , B.ADSTRD_NM AS ADSTRD_NM
                    , A.AGRDE_SE_CD
                    , A.POPLTN_CNT
            FROM TB_POPLTN A, TB_ADSTRD B
            WHERE A.POPLTN_SE_CD = 'T'
                AND A.STD_YM = '202010'
                AND A.ADSTRD_CD = B.ADSTRD_CD
                AND A.POPLTN_CNT > 0
                AND B.ADSTRD_NM LIKE '경기도%고양시%덕양구%'
            ORDER BY A.ADSTRD_CD
        ) A
;        

SELECT A.SUBWAY_STATN_NO AS 지하철역번호
        , A.LN_NM AS 노선명
        , A.STATN_NM AS 역명
        , B.STD_YM AS 기준년월
        , B.BEGIN_TIME AS 시작시간
        , B.END_TIME AS 종료시간
        , (SELECT L.TK_GFF_SE_NM
            FROM TB_TK_GFF_SE L
            WHERE L.TK_GFF_SE_CD = B.TK_GFF_SE_CD
            ) AS 승차구분명
        , B.TK_GFF_CNT AS 승하차횟수
        , FIRST_VALUE(B.TK_GFF_CNT) OVER(PARTITION BY B.TK_GFF_SE_CD
                                                                        ORDER BY B.BEGIN_TIME
                                                                        ROWS UNBOUNDED PRECEDING
                                                                ) AS FIRST_VALUE
        , LAST_VALUE(B.TK_GFF_CNT) OVER(PARTITION BY B.TK_GFF_SE_CD
                                                                        ORDER BY B.BEGIN_TIME
                                                                        ROWS BETWEEN CURRENT ROW
                                                                                        AND UNBOUNDED FOLLOWING
                                                                ) AS LAST_VALUE
        , LAG(B.TK_GFF_CNT, 1) OVER(PARTITION BY B.TK_GFF_SE_CD
                                                            ORDER BY B.BEGIN_TIME
                                                        ) AS LAG
        , LEAD(B.TK_GFF_CNT, 1) OVER(PARTITION BY B.TK_GFF_SE_CD
                                                            ORDER BY B.BEGIN_TIME
                                                        ) AS LEAD
FROM TB_SUBWAY_STATN A
        , TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO = '000031'
    AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
    AND B.BEGIN_TIME BETWEEN '0700' AND '1000'
    AND B.END_TIME BETWEEN '0800' AND '1100'
    AND B.STD_YM = '202010'
ORDER BY B.TK_GFF_SE_CD, B.BEGIN_TIME
;

SELECT A.SUBWAY_STATN_NO AS 지하철역번호
        , A.LN_NM AS 노선명
        , A.STATN_NM AS 역명
        , B.STD_YM AS 기준년월
        , B.BEGIN_TIME AS 시작시간
        , B.END_TIME AS 종료시간
        , (SELECT L.TK_GFF_SE_NM
                FROM TB_TK_GFF_SE L
            WHERE L.TK_GFF_SE_CD = B.TK_GFF_SE_CD
            ) AS 승차구분명
        , B.TK_GFF_CNT AS 승하차횟수
        , ROUND(RATIO_TO_REPORT(B.TK_GFF_CNT) OVER(PARTITION BY B.TK_GFF_SE_CD), 2) AS RATIO_TO_REPORT
        , ROUND(PERCENT_RANK() OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS PERCENT_RANK
        , ROUND(CUME_DIST() OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS CUME_DIST
        , ROUND(NTILE(2) OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS NTILE
FROM TB_SUBWAY_STATN A
        , TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO = '000031'
    AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
    AND B.BEGIN_TIME BETWEEN '0700' AND '1000'
    AND B.END_TIME BETWEEN '0800' AND '1100'
    AND B.STD_YM = '202010'
ORDER BY B.TK_GFF_SE_CD, B.TK_GFF_CNT
;


