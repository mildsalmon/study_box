import pandas as pd
import sqlalchemy

engine = sqlalchemy.create_engine('sqlite:///sample.db')

query = '''
SELECT substr(time, 1, 10) time, count(*) count
FROM access_log
WHERE time BETWEEN '1995-07-01' AND '1995-07-04'
GROUP BY 1
ORDER BY 1
'''

sql = pd.read_sql(query, engine)

print(sql)