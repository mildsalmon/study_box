SELECT
      COUNT(*) AS "전체상가수"
    , MAX(LO) AS "최대경도"
    , MIN(LO) AS "최소경도"
    , MAX(LA) AS "최대위도"
    , MIN(LA) AS "최소위도"
FROM TB_BSSH
;

SELECT A.SUBWAY_STATN_NO
    , A.LN_NM
    , A.STATN_NM
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역'
;

SELECT MAX(A.SUBWAY_STATN_NO)
    , MAX(A.LN_NM)
    , MAX(A.STATN_NM)
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역'
;

SELECT NVL(MAX(A.SUBWAY_STATN_NO), '지하철역없음') AS SUBWAY_NO
    , NVL(MAX(A.LN_NM), '노선명없음') AS LN_NM
    , NVL(MAX(A.STATN_NM), '역명없음') AS STATN_NM
FROM TB_SUBWAY_STATN A
WHERE A.STATN_NM = '평양역'
;

SELECT A.POPLTN_SE_CD
    , SUM(A.POPLTN_CNT) AS "인구수합계"
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
GROUP BY A.POPLTN_SE_CD
;

SELECT A.POPLTN_SE_CD
    , A.AGRDE_SE_CD
    , SUM(A.POPLTN_CNT) AS "인구수합계"
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
GROUP BY A.POPLTN_SE_CD, A.AGRDE_SE_CD
HAVING SUM(A.POPLTN_CNT) < 1000000
;

SELECT A.SUBWAY_STATN_NO
    , SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS001' THEN A.TK_GFF_CNT
                    ELSE 0
              END) AS "승차인원수합계"
    , SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS002' THEN A.TK_GFF_CNT
                    ELSE 0
                END) AS "하차인원수합계"
    , SUM(CASE WHEN A.BEGIN_TIME = '0800'
                            AND A.END_TIME = '0900'
                            AND A.TK_GFF_SE_CD = 'TGS001'
                        THEN A.TK_GFF_CNT
                    ELSE 0
                END) AS "출근시간대승차인원수합계"
    , SUM(CASE WHEN A.BEGIN_TIME = '0800'
                            AND A.END_TIME = '0900'
                            AND A.TK_GFF_SE_CD = 'TGS002'
                        THEN A.TK_GFF_CNT
                    ELSE 0
                END) AS "출근시간대하차인원수합계"
    , SUM(CASE WHEN A.BEGIN_TIME = '1800'
                            AND A.END_TIME = '1900'
                            AND A.TK_GFF_SE_CD = 'TGS001'
                        THEN A.TK_GFF_CNT
                    ELSE 0
                END) AS "퇴근시간대승차인원수합계"
    , SUM(CASE WHEN A.BEGIN_TIME = '1800'
                            AND A.END_TIME = '1900'
                            AND A.TK_GFF_SE_CD = 'TGS002'
                        THEN A.TK_GFF_CNT
                    ELSE 0
                END) AS "퇴근시간대하차인원수합계"
    , SUM(TK_GFF_CNT) AS "승하차인원수합계"
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.STD_YM = '202010'
GROUP BY A.SUBWAY_STATN_NO
HAVING SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS001'
                                THEN A.TK_GFF_CNT
                            ELSE 0
                        END) >= 1000000
            OR SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS002'
                                    THEN A.TK_GFF_CNT
                                ELSE 0
                            END) >= 1000000
;                            