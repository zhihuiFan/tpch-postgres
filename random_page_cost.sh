#!/bin/bash

# run every query in TPCH in different random_page_cost settings.
# we need to know the plan difference and run time difference.

source ./env.sh

function explain_query {
    random_page_cost=$1
    query_id=$2

    # for seq = 1, we add the logfile, for others, we just echo the content
    # so that we can get the difference.
    seq=$3

    # clear file system cache and shared_buffer cache.
    $PG_CTL stop -D $PG_DIR
    sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches; free -g"
    $PG_CTL start -D $PG_DIR -o --random_page_cost=${random_page_cost}
    
    # get the plan.
    $PG_SQL tpch10g -f q${query_id}.explain.sql > logs/q${query_id}.explain.log
    
    if [ "$seq" == "1" ]; then
	cd logs
	git add q${query_id}.explain.log
	cd ..
    fi
}


function run_query_with_zero_cache {
    random_page_cost=$1
    query_file=$2
    seq=${3}

    # clear file system cache and shared_buffer cache.
    $PG_CTL stop -D $PG_DIR
    sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches; free -g"
    $PG_CTL start -D $PG_DIR -o --random_page_cost=${random_page_cost}

    $PG_SQL ${DB_NAME} -f ${query_file} > logs/${query_file}.log
    
    if [ "$seq" == "1" ]; then
	cd logs
	git add ${query_file}.log
	cd ..
    fi
}

function main {
    base_random_page_cost=$1
    adjusted_random_page_cost=$2

    # the the explain only
    for query_id in `seq 0 21`; do
	explain_query $base_random_page_cost $query_id 1
	explain_query $adjusted_random_page_cost $query_id 2
    done

    # get which plan changed.
    cd logs
    sql_files=`git status | grep modified | awk '{print $2}' | sed -e 's/explain.log/run.sql/'`
    cd ..
    echo $sql_files
    for sql_file in ${sql_files}; do
	echo "Running ${sql_file}.."
	run_query_with_zero_cache $base_random_page_cost $sql_file 1
	run_query_with_zero_cache $adjusted_random_page_cost $sql_file 2
    done

    cd logs/
    git commit -m "plan and execution stats for random_page_cost=$base_random_page_cost"
    git add *.explain.log
    git commit -m "commit the plan changes for random_page_cost=$adjusted_random_page_cost"
    git commit -am "commit the execution stat changes for random_page_cost=$adjusted_random_page_cost"
    cd ..
}

rm -rf logs
git init logs
starttime=`date`
main 4.0 8.6
echo $starttime `date`
