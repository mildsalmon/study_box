import pandas as pd

df1 = pd.read_csv('access_log.csv', parse_dates=['time'])
df2 = df1.set_index('time')
df3 = df2['1995-07-01' : '1995-07-03']

print(df1)
print(df2)
print(df3)

df4 = df3.resample('1d').size()

print(df4)