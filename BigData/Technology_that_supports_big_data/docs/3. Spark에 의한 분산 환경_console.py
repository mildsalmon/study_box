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

# # Spark에 의한 분산 환경

pyspark --packages org.mongodb.spark:mongo-spark-connector_2.11:2.2.0

# Spark세션 정보에 접근하기 위한 변수
spark

# ### A. MongoDB의 애드 혹 집계

# +
# MongoDB로 부터 데이터가져와서 데이터프레임 형태로 변경
df = (spark.read
    .format("com.mongodb.spark.sql.DefaultSource")
    .option("uri", "mongodb://localhost/twitter.sample")
    .load())

# 데이터프레임을 일시적인 뷰로 등록
df.createOrReplaceTempView('tweets')

# 언어별 트윗 수의 상위 3건 표시하는 쿼리 작성
query = '''
SELECT lang, count(*) count
FROM tweets 
WHERE delete IS NULL 
GROUP BY 1
ORDER BY 2 DESC
'''

# 쿼리 실행
spark.sql(query).show(3)

# + active=""
# +----+-----+
# |lang|count|
# +----+-----+
# |  ja|42322|
# |  en|41562|
# | und|12847|
# +----+-----+
# only showing top 3 rows
# -

# ### B. 텍스트 데이터의 가공

# +
# 영어 트윗과 글작성 시간 추출
en_query = '''
SELECT from_unixtime(timestamp_ms / 1000) time,
       text
FROM tweets
WHERE lang='en'
'''

# en_query를 실행해서 데이터프레임을 만든다.
en_tweets=spark.sql(en_query)

from pyspark.sql import Row

# 트윗을 단어로 분해하는 제네레이터 함수
def text_split(row):
    for word in row.text.split():
        yield Row(time=row.time, word=word)
        
# '.rdd'로 원시 레코드 참조
en_tweets.rdd.take(1)

# + active=""
# [Row(time='2022-02-01 20:13:20', text='***New In***Vintage Union Jack Flags. https://t.co/C2vB2LnJ9d')]
# -

# flatMap()에 제네레이터 함수 적용
en_tweets.rdd.flatMap(text_split).take(2)

# + active=""
# [Row(time='2022-02-01 20:13:20', word='***New'), Row(time='2022-02-01 20:13:20', word='In***Vintage')]
# -

# toDF()를 사용해 데이터 프레임으로 변환
en_tweets.rdd.flatMap(text_split).toDF().show(2)

# + active=""
# +-------------------+------------+
# |               time|        word|
# +-------------------+------------+
# |2022-02-01 20:13:20|      ***New|
# |2022-02-01 20:13:20|In***Vintage|
# +-------------------+------------+
# only showing top 2 rows
# -

# ### C. Spark 프로그램에 있어서의 DAG 실행

# +
# 분해한 단어로 이루어진 뷰 'words'를 작성
words = en_tweets.rdd.flatMap(text_split).toDF()
words.createOrReplaceTempView('words')

# 단어별 카운트의 상위 3건을 표시
word_count_query = '''
SELECT word, count(*) count
FROM words
GROUP BY 1
ORDER BY 2 DESC
'''

spark.sql(query).show(3)

# + active=""
# +----+-----+
# |lang|count|
# +----+-----+
# |  ja|43337|
# |  en|42705|
# | und|13121|
# +----+-----+
# only showing top 3 rows

# +
# 분해한 단어를 테이블로 보관
words.write.saveAsTable('twitter_sample_words')

# 초기 설정에서는 'spark-warehouse'에 파일이 저장된다.
# ./spark-warehouse
# -


