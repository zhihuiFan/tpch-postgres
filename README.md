This repo can be used to test some optimizer feature correctness and performance
gain with TPC-H workload.  It is an intermediate results of [1], so that you
don't need to install pgdexter, hgpopg extension and so on.


How can it be used?
-- 
1. Load the schema and data.

```
tar -xf data.gz
psql -a {your_db_name} -f data.sql
psql -a {your_db_name} -c "analyze;"
```

2. Get the execution plan and run-time statistics with the original pg
   version. You might want to run twice to avoid the io impacts.

```
psql -a {db_name} -f explain.analyze.sql > explain.analyze.normal.log
```

3. Snapshot the current result with the original pg version

```
psql -a {dbname} -f capture.result.sql 
```

4. apply the patch you want to test.
5. run explain.analyze.sql again and compare the result
6. run diff.sql to compare the result with the previous snapshot. The expect is
   every query return 0 rows (no difference)

Note: 
1. The size of data.gz is about 307MB, so it may take some time to clone this
repo. 
2. If you want to build more analysis script, you can check
   generate_derived_sql.py first.

I didn't spend much time on this,  if you find any issue/improvements, just open
an issue. Thanks

[1] https://ankane.org/tpc-h
