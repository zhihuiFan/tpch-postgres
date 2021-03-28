#!/bin/bash

source ./env.sh

$PG_SQL postgres -c "drop database ${DB_NAME};"
set -e
$PG_SQL postgres -c "create database ${DB_NAME};"
start=`date`
$PG_SQL ${DB_NAME} -f data.sql
$PG_SQL ${DB_NAME} -f create_view.sql
$PG_SQL ${DB_NAME} -f index.sql
$PG_SQL ${DB_NAME} -C "analyze"
end=`date`
echo "Start at $start"
echo "End at $end"
