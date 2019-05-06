#!/bin/bash
echo "listen_addresses='*'" >> /postgres/data/postgresql.conf
echo "port = 5432" >> /postgres/data/postgresql.conf
echo "host    all             all             0.0.0.0/0 md5" >> /postgres/data/pg_hba.conf

pg_ctl start -D /postgres/data/
psql  -c "ALTER USER postgres WITH PASSWORD 'postgres';create user pgc_dump with password 'pgc_dump';"
psql  -c "create database pgc_dump owner pgc_dump;"
psql  -c "create user test with password 'test';"
psql  -c "create database testdb owner test;"
psql -U test -d testdb -c "CREATE SCHEMA test;"
psql -U test -d testdb -c "ALTER SCHEMA test OWNER TO test;"
psql -U test -d testdb -c "GRANT ALL ON SCHEMA test TO test;"
psql -U test -d testdb -c "GRANT ALL PRIVILEGES ON DATABASE testdb TO test;"
psql -U test -d testdb -c "create table test.test_dump(id integer ,name varchar(100),PRIMARY KEY (id));"
cat /postgres/sh/init-pgc-dump-11.1.dmp | psql pgc_dump >/dev/null 2>&1 

