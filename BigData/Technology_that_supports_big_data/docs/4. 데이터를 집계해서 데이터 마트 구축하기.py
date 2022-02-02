# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.13.6
#   kernelspec:
#     display_name: big_data
#     language: python
#     name: big_data
# ---

# # 1. 데이터를 집계해서 데이터 마트 구축하기

# 모든 레코드 수 확인
spark.table('twitter_sample_words').count()

# + active=""
# 411500

# +
# 1시간마다 그룹화하여 집계
query = '''
    -- 선두 13문자 : "YYYY-MM-DD HH"
SELECT substr(time, 1, 13) time,
    word,
    count(*) count
FROM twitter_sample_words
GROUP BY 1, 2
'''

spark.sql(query).count()

# + active=""
# 94929
# -

# ## A. 카디널리티의 삭감

# +
# 등장 횟수가 적은 단어의 수를 조사한다.
query = '''
SELECT t.count,
       count(*) words
FROM (
    -- 단어별 카운트
    SELECT word,
           count(*) count
    FROM twitter_sample_words
    GROUP BY 1
) t
GROUP BY 1
ORDER BY 1
'''

spark.sql(query).show(3)

# + active=""
# +-----+-----+
# |count|words|
# +-----+-----+
# |    1|69388|
# |    2|10578|
# |    3| 4192|
# +-----+-----+
# only showing top 3 rows

# +
# 단어를 카테고리로 나누는 디멘전 테이블
query = '''
SELECT word,
       count,
       IF(count > 1000, word, concat('COUNT=', count)) category
FROM (
    SELECT word,
           count(*) count
    FROM twitter_sample_words
    GROUP BY 1
) t
'''

spark.sql(query).show(5)

# + active=""
# +------------+-----+---------+
# |        word|count| category|
# +------------+-----+---------+
# |       team!|   31| COUNT=31|
# |       still|  281|COUNT=281|
# |@wildcardp2e|    2|  COUNT=2|
# |      outfit|   13| COUNT=13|
# |      jihoon|    2|  COUNT=2|
# +------------+-----+---------+
# only showing top 5 rows
# -

# 일시적인 뷰로 등록
spark.sql(query).createOrReplaceTempView('word_category')

# +
# 1시간마다 카테고리별로 그룹화하여 집계
query = '''
SELECT substr(a.time, 1, 13) time,
       b.category,
       count(*) count
FROM twitter_sample_words a
    LEFT JOIN word_category b ON a.word = b.word
GROUP BY 1, 2
'''

spark.sql(query).count()

# + active=""
# 342
# -

# ## B. CSV 파일의 작성

# ### a. 표준 spark-csv 라이브러리 사용

# +
(spark.sql(query)
      .coalesce(1) # 출력 파일은 하나로 한다.
      .write.format('com.databricks.spark.csv') # CSV형식
      .option('header', 'true') # 헤더 있음
      .save('csv_output')) # 출력 디렉토리

# csv 파일은
# ./csv_output 디렉토리에 존재한다.
# -

# ### b. pandas의 데이터 프레임

# pandas의 데이터 프레임으로 변환
result = spark.sql(query).toPandas()
# 데이터 프레임 확인. 'time'이 도중에 끊겨 있다.
result.head(2)

# + active=""
#             time   category  count
# 0  2022-02-01 20          I   3549
# 1  2022-02-01 20  COUNT=138    414

# +
# 표준화된 시간형으로 변환
import pandas as pd

result['time'] = pd.to_datetime(result['time'])
result.head(2)

# + active=""
#                  time   category  count
# 0 2022-02-01 20:00:00          I   3549
# 1 2022-02-01 20:00:00  COUNT=138    414
# -

# 변경 후의 데이터 프레임을 보관
result.to_csv('word_summary.csv', index=False, encoding='utf-8')
