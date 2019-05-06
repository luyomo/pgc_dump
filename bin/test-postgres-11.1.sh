#!/bin/sh

#source db
source_user=test
source_pwd=test
source_port=5432
source_db=testdb
source_version=1
source_host=localhost
#pgc_dump db 
pgc_host=localhost
pgc_pwd=pgc_dump
pgc_db=pgc_dump
pgc_port=5432
pgc_user=pgc_dump

#set table name compara
table_name=test_dump

rm -rf /tmp/*.csv /tmp/source_table.dmp /tmp/pgc_dump.dmp

echo "Copy data from source db Host : $source_host dbname : $source_db Port : $source_port User : $source_user"
export PGPASSWORD=$source_pwd
# copy from source db to csv
psql -h $source_host -p $source_port -U $source_user -d $source_db -f /test/cp_from/init-ddl.sql >/dev/null 2>&1
psql -h $source_host -p $source_port -U $source_user -d $source_db -v db="'$source_db'" -v ver="'$source_version'" -f /test/cp_from/cp_from_11.1.sh >/dev/null 2>&1 

echo "Copy data from source db completed......"
echo "Load data to config DB  ......"
#load csv to pgc_dump
export PGPASSWORD=$pgc_pwd
psql -h $pgc_host -p $pgc_port -U $pgc_user -d $pgc_db -v db="'$source_db'" -v ver="'$source_version'" -f /test/cp_to/cp_to_11.1.sh >/dev/null 2>&1

echo "Load data to config DB completed......"
echo "pg_dump from source db object : $table_name  Host : $source_host dbname : $source_db Port : $source_port User : $source_user"
#pg_dump table
export PGPASSWORD=$source_pwd
pg_dump -F p -f /tmp/source_table.dmp -s -t $table_name -x -b -E UTF8  -h $source_host -p $source_port -U $source_user $source_db

echo "pg_dump from source db  completed   /tmp/source_table.dmp......"
echo "Clean test data from source db........."
#clean test table
export PGPASSWORD=$source_pwd
psql -h $source_host -p $source_port -U $source_user -d $source_db -f /test/cp_from/clean-ddl.sql >/dev/null 2>&1
echo "Clean test data from source db completed........."
echo "pgc_dump from config db ............"
#pgc_dump table
export PGPASSWORD=$pgc_pwd
pgc_dump -F p -f /tmp/pgc_dump.dmp -s -D $source_db -V $source_version -t $table_name -x -b -E UTF8  -h $pgc_host -p $pgc_port -U $pgc_user $pgc_db
echo "pgc_dump from config db completed /tmp/pgc_dump.dmp............"

/test/cp_to/diff_compare.sh $table_name
