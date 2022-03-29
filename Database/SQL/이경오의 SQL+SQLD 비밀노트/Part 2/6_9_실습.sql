SELECT A.ADSTRD_CD
    , SUM(A.POPLTN_CNT) POPLTN_CNT
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
    AND A.POPLTN_SE_CD = 'T'
    GROUP BY A.ADSTRD_CD
;    

--코드 6-107 읍/면/동별 전체 인구수합계 집합과 상가 테이블을 조인
SELECT A.ADSTRD_CD
     , B.ADSTRD_NM
     , A.POPLTN_CNT
     , COUNT(*) COFFEE_CNT
  FROM
     (
       SELECT /*+ NO_MERGE */
              A.ADSTRD_CD
            , SUM(A.POPLTN_CNT) POPLTN_CNT
         FROM TB_POPLTN A
        WHERE A.STD_YM = '202010'
          AND A.POPLTN_SE_CD = 'T'
        GROUP BY A.ADSTRD_CD
     ) A
     , TB_ADSTRD B
     , TB_BSSH C
 WHERE A.ADSTRD_CD = B.ADSTRD_CD
   AND B.ADSTRD_CD = C.ADSTRD_CD
   AND C.INDUTY_SMALL_CL_CD = 'Q12A01'
 GROUP BY A.ADSTRD_CD, B.ADSTRD_NM, A.POPLTN_CNT
;

--코드 6-108 읍/면/동별 커피숍 1개당 인구수
SELECT A.ADSTRD_CD
     , A.ADSTRD_NM
     , A.POPLTN_CNT
     , A.COFFEE_CNT
     , TRUNC(A.POPLTN_CNT/A.COFFEE_CNT) AS 커피숍1개당인구수
  FROM
     (
       SELECT A.ADSTRD_CD
            , B.ADSTRD_NM
            , A.POPLTN_CNT
            , COUNT(*) COFFEE_CNT
         FROM
            (
              SELECT A.ADSTRD_CD
                   , SUM(A.POPLTN_CNT) POPLTN_CNT
                FROM TB_POPLTN A
               WHERE A.STD_YM = '202010'
                 AND A.POPLTN_SE_CD = 'T'
               GROUP BY A.ADSTRD_CD
            ) A
            , TB_ADSTRD B
            , TB_BSSH C
        WHERE A.ADSTRD_CD = B.ADSTRD_CD
          AND B.ADSTRD_CD = C.ADSTRD_CD
          AND C.INDUTY_SMALL_CL_CD = 'Q12A01'
        GROUP BY A.ADSTRD_CD, A.POPLTN_CNT, B.ADSTRD_NM
      ) A
 ORDER BY 커피숍1개당인구수 DESC
;

--코드 6-109 시/군/구별 인구수합계
SELECT SUBSTR(A.ADSTRD_CD, 1, 5) 시군구코드
     , (SELECT L.ADRES_CL_NM
          FROM TB_ADRES_CL L
         WHERE L.ADRES_CL_SE_CD = 'ACS001'
           AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD) 시도
     , B.ADRES_CL_NM 시군구
     , SUM(A.POPLTN_CNT) 인구수
  FROM TB_POPLTN A , TB_ADRES_CL B
 WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
   AND B.ADRES_CL_SE_CD = 'ACS002'
   AND A.POPLTN_SE_CD = 'T'
   AND A.AGRDE_SE_CD IN ('000', '010')
 GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5), B.ADRES_CL_NM, B.UPPER_ADRES_CL_CD
 ORDER BY 시군구코드
;

--코드 6-110 시/군/구별 00대~10대 인구수합계 기준 학원 1개당 인구수 조회
SELECT A.시군구코드
     , A.시도
     , A.시군구
     , A.인구수
     , A.ACADEMY_CNT
     , TRUNC(A.인구수/A.ACADEMY_CNT) AS 학원1개당인구수
  FROM
     (
       SELECT A.시군구코드
            , A.시도
            , A.시군구
            , A.인구수
            , COUNT(*) ACADEMY_CNT
         FROM
            (
               SELECT SUBSTR(A.ADSTRD_CD, 1, 5) 시군구코드
                    , (SELECT L.ADRES_CL_NM
                         FROM TB_ADRES_CL L
                        WHERE L.ADRES_CL_SE_CD = 'ACS001'
                          AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD
                       ) 시도
                    , B.ADRES_CL_NM 시군구
                    , SUM(A.POPLTN_CNT) 인구수
                 FROM TB_POPLTN A
                    , TB_ADRES_CL B
                WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
                  AND B.ADRES_CL_SE_CD = 'ACS002'
                  AND A.POPLTN_SE_CD = 'T'
                  AND A.AGRDE_SE_CD IN ('000', '010')
                GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5)
                       , B.ADRES_CL_NM
                       , B.UPPER_ADRES_CL_CD
                ORDER BY 시군구코드
            ) A
            , TB_BSSH C
        WHERE 1=1
          AND A.시군구코드 = C.SIGNGU_CD
          AND C.INDUTY_MIDDL_CL_CD IN (
                                        'R01' --학원-보습교습입시
                                      , 'R02' --학원-창업취업취미
                                      , 'R03' --학원-자격/국가고시
                                      , 'R04' --학원-어학
                                      , 'R05' --학원-음악미술무용
                                      , 'R06' --학원-컴퓨터
                                      , 'R07' --학원-예능취미체육
                                      , 'R08' --유아교육
                                      )
        GROUP BY A.시군구코드, A.시도, A.시군구, A.인구수
    ) A
ORDER BY 학원1개당인구수 DESC
;

--코드 6-111 지하철역별 승하차인원수 합계
SELECT A.SUBWAY_STATN_NO
     , B.STATN_NM
     , B.LN_NM
     , SUM(A.TK_GFF_CNT) AS SUM_TK_GFF_CNT
  FROM TB_SUBWAY_STATN_TK_GFF A
     , TB_SUBWAY_STATN B
 WHERE A.STD_YM = '202010'
   AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
 GROUP BY A.SUBWAY_STATN_NO, B.STATN_NM, B.LN_NM
 ORDER BY SUM_TK_GFF_CNT DESC
;

--코드 6-112 노선별 승하차인원수 합계 1위 구하기
SELECT *
  FROM
     (
       SELECT A.SUBWAY_STATN_NO
            , A.STATN_NM
            , A.LN_NM
            , A.SUM_TK_GFF_CNT
            , ROW_NUMBER() OVER(PARTITION BY A.LN_NM ORDER BY A.SUM_TK_GFF_CNT DESC) AS RNUM_LN_NM_SUM_TK_GFF_CNT
         FROM
            (
              SELECT A.SUBWAY_STATN_NO
                   , B.STATN_NM
                   , B.LN_NM
                   , SUM(A.TK_GFF_CNT) AS SUM_TK_GFF_CNT
                FROM TB_SUBWAY_STATN_TK_GFF A
                   , TB_SUBWAY_STATN B
               WHERE A.STD_YM = '202010'
                 AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
               GROUP BY A.SUBWAY_STATN_NO , B.STATN_NM, B.LN_NM
               ORDER BY SUM_TK_GFF_CNT DESC
            ) A
     ) A
 WHERE RNUM_LN_NM_SUM_TK_GFF_CNT = 1
 ORDER BY SUM_TK_GFF_CNT DESC
;