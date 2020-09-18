#!/bin/bash

# run every query in TPCH in different random_page_cost settings.
# we need to know the plan difference and run time difference.

source ./env.sh

function run_query_with_no_cache {
    random_page_cost=$1
    query_id=$2

    # for seq = 1, we add the logfile, for others, we just echo the content
    # so that we can get the difference.
    seq=$3

    # not really run, just get the plan.
    real_run=$4

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

    if [ "real_run" == "1" ]; then
	$PG_SQL tpch10g -f q${query_id}.run.sql > logs/q${query_id}.run.log

	if [ "$seq" == "1" ]; then
	    cd logs
	    git add q${query_id}.run.log
	    cd ..
	fi
    fi
}


function main {
    base_random_page_cost=$1
    adjusted_random_page_cost=$2
    real_run=$3

    for query_id in `seq 0 1`; do
	run_query_with_no_cache $base_random_page_cost $query_id 1 $real_run
	run_query_with_no_cache $adjusted_random_page_cost $query_id 2 $real_run
    done
}


rm -rf logs
git init logs
main 4.0 8.2
