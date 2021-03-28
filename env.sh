#!/bin/bash
PGSRC=basepg
PG_HOME=/u01/yizhi/bin/${PGSRC}
PG_DIR=/u01/yizhi/data/${PGSRC}
PG_CTL=${PG_HOME}/bin/pg_ctl
PG_SQL="${PG_HOME}/bin/psql -X"
DB_NAME=tpch10g
