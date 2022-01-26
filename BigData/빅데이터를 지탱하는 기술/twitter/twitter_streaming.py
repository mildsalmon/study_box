import requests_oauthlib
from api import key
import datetime
import json
from pymongo import MongoClient
import tqdm

"""
Twitter Developers 사이트에서 API 키 발행
"""
consumer_key = key.twitter_API_Key
consumer_secret = key.twitter_API_Key_Secret
access_token_key = key.twitter_access_token
access_token_secret = key.twitter_access_secret

"""
Twitter 스트리밍 API 실행
"""
twitter = requests_oauthlib.OAuth1Session(consumer_key, consumer_secret, access_token_key, access_token_secret)
uri = "https://stream.twitter.com/1.1/statuses/sample.json"
response = twitter.get(uri, stream=True)
response.raise_for_status()

"""
MongoDB에서 database와 collection 연결
"""
host = 'localhost'
port = 27017

mongo_client = MongoClient(host=host, port=port)
database = mongo_client.get_database('mydb')
collection = database.get_collection('twitter')

# print(mongo_client.list_database_names())
# print(database)
# print(collection)

"""
샘플링된 트윗을 MongoDB에 보관

tqdm은 아래처럼 현재 진행상황을 보여줌
    148289tweets [52:30, 50.19tweets/s]
"""
for line in tqdm.tqdm(response.iter_lines(), unit='tweets', mininterval=1):
    if line:
        tweet = json.loads(line)
        # print(tweet)
        tweet['_timestamp'] = datetime.datetime.utcnow().isoformat()
        collection.insert_one(tweet)