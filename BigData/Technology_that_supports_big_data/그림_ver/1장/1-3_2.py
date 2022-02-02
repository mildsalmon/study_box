import re
import pandas as pd

pattern = re.compile('^\S+ \S+ \S+ \[(.*)\] "(.*)" (\S+) (\S+)$')

def parse_access_log(path):
    for line in open(path):
        for m in pattern.finditer(line):
            yield m.groups()
            # groups()는 정규식에서 ()로 감싼 부분만 반환한다.

columns = ['time', 'request', 'status', 'bytes']
df = pd.DataFrame(parse_access_log('access.log'), columns=columns)

print(df)

#################################

df = pd.DataFrame(parse_access_log('access.log'), columns=columns)
df.time = pd.to_datetime(df.time, format='%d/%b/%Y:%X', exact=False)

print(df)

#################################

df.to_csv('access_log.csv', index=False)