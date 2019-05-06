#!/bin/sh
_cid="None"
_file=$1;
_flag=0

for x in $(docker ps | awk '{if (NR>1) {print $1,$2}}')
do     
    if [[ "${x%:*}" == "pgc_dump_11.1" ]];then
        #echo "get --- $x"
        #echo $_cid
        _flag=1
        docker exec -it $_cid bash  -c "su - postgres -s /bin/bash -c '/test/$_file'"
    fi
    _cid=$x
done
if [ $_flag -eq 0 ]; then
    echo "  Worning info : Docker image not runing , can run docker images first......"
fi