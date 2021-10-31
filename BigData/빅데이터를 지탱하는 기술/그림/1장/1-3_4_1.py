sqlite3 sample.db

CREATE TABLE access_log (
time timestamp,
request text,
status bigint,
bytes bigint
);

.separator ,
.import access_log.csv access_log
