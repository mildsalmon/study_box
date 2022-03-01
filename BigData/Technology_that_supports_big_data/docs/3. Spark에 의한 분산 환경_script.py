# -*- coding: utf-8 -*-
# # 3. Spark에 의한 분산 환경

import findspark
findspark.init()

from pyspark.sql import SparkSession
#sparksession 드라이버 프로세스 얻기
spark = SparkSession\
    .builder\
    .master("local[*]")\
    .config('spark.mongodb.input.uri', 'mongodb://localhost/twitter.sample')\
    .config('spark.mongodb.output.uri', 'mongodb://localhost/twitter.sample')\
    .config('spark.jars.packages', 'org.mongodb.spark:mongo-spark-connector_2.11:2.2.0')\
    .getOrCreate()
#클러스터모드의 경우 master에 local[*] 대신 yarn이 들어간다.

spark.conf.set("spark.sql.repl.eagerEval.enabled",True)
#jupyter환경에서만 가능한 config, .show()메소드를 사용할 필요없이 dataframe만 실행해도,정렬된 프린팅을 해준다.

# ### A. MongoDB의 애드 혹 집계

#MongoDB로 부터 데이터가져와서 데이터프레임 형태로 변경
df = spark.read\
    .format("com.mongodb.spark.sql.DefaultSource")\
    .load()

#데이터프레임을 일시적인 뷰로 등록
df.createOrReplaceTempView('tweets')

#언어별 트윗 수의 상위 3건 표시하는 쿼리 작성
query = '''
SELECT lang, count(*) count
FROM tweets 
WHERE delete IS NULL 
GROUP BY 1
ORDER BY 2 DESC
'''

#쿼리 실행
spark.sql(query).show(3)

# ### B. 텍스트 데이터의 가공

# 영어 트윗과 글작성 시간 추출
en_query = '''
SELECT from_unixtime(timestamp_ms / 1000) time,
       text
FROM tweets
WHERE lang='en'
'''

# en_query를 실행해서 데이터프레임을 만든다.
en_tweets = spark.sql(en_query)

from pyspark.sql import Row


# 트윗을 단어로 분해하는 제네레이터 함수
def text_split(row):
    for word in row.text.split():
        yield Row(time=row.time, word=word)


# '.rdd'로 원시 레코드 참조
en_tweets.rdd.take(1)

# flatMap()에 제네레이터 함수 적용
en_tweets.rdd.flatMap(text_split).take(2)

# toDF()를 사용해 데이터 프레임으로 변환
en_tweets.rdd.flatMap(text_split).toDF().show(2)

# ### C. Spark 프로그램에 있어서의 DAG 실행

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

# 분해한 단어를 테이블로 보관
words.write.saveAsTable('twitter_sample_words')

# # 4. 데이터를 집계해서 데이터 마트 구축하기

# 모든 레코드 수 확인
spark.table('twitter_sample_words').count()

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
# -

# ### A. 카디널리티의 삭감

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
# -

# ### B. CSV 파일의 작성

# ##### a. 표준 spark-csv 라이브러리 사용

# +
(spark.sql(query)
      .coalesce(1) # 출력 파일은 하나로 한다.
      .write.format('com.databricks.spark.csv') # CSV형식
      .option('header', 'true') # 헤더 있음
      .save('csv_output')) # 출력 디렉토리

# csv 파일은
# ./csv_output 디렉토리에 존재한다.
# -
# ##### b. pandas의 데이터 프레임


# pandas의 데이터 프레임으로 변환
result = spark.sql(query).toPandas()
# 데이터 프레임 확인. 'time'이 도중에 끊겨 있다.
result.head(2)

# +
# 표준화된 시간형으로 변환
import pandas as pd

result['time'] = pd.to_datetime(result['time'])
result.head(2)
# -

# 변경 후의 데이터 프레임을 보관
result.to_csv('word_summary.csv', index=False, encoding='utf-8')
