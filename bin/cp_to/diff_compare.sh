#!/bin/bash
table_name=$1
sed -i 's/pg_catalog.set_config/pgc_dump.set_config/g' /tmp/source_table.dmp
echo "============== Compare start........  ===================="
echo "Compare object : $table_name"
echo "Compare files  : /tmp/source_table.dmp /tmp/pgc_dump.dmp"
echo "Compare diff   : "
diff -b -B -I -- -I SET -I set_config /tmp/source_table.dmp /tmp/pgc_dump.dmp
echo "Detail can see files /tmp/source_table.dmp /tmp/pgc_dump.dmp.."
echo "============== Compare end........  ===================="
