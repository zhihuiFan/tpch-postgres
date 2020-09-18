queries = []
d_queries = []
with open('raw_queries.sql') as r:
    d_queries = r.read().split(';')

assert len(d_queries) == 25
for idx, query in enumerate(d_queries):
    query = query.strip()
    if query.startswith('create view'):
        assert idx == 14
    if query.startswith('drop view'):
        assert idx == 16
    if not query:
        assert idx == 24
        continue
    queries.append(query)

assert len(queries) == 24, len(queries)

with open('explain.analyze.sql', 'w') as g1:
    for idx, q in enumerate(queries):
        if idx in [14, 16]:
            g1.write("%s;\n\n" % q)
            continue
        sql = "explain (analyze, verbose, buffers) %s;\n\n" % (q)
        g1.write(sql)

with open('explain.costoff.sql', 'w') as g1:
    for idx, q in enumerate(queries):
        if idx in [14, 16]:
            g1.write("%s;\n\n" % q)
            continue
        sql = "explain (costs off) %s;\n\n" % (q)
        g1.write(sql)


with open('capture.result.sql', 'w') as g1:
    for idx, q in enumerate(queries):
        if idx in [14, 16]:
            g1.write("%s;\n\n" % q)
            continue
        sql = "drop table query_%d;\ncreate table query_%d as %s;\n\n" % (idx, idx, q)
        g1.write(sql)


with open('diff.sql', 'w') as g1:
    for idx, q in enumerate(queries):
        if idx in [14, 16]:
            g1.write("%s;\n\n" % q)
            continue
        sql = '''
(select * from query_%d except all (%s))
 union all
((%s) except all select * from query_%d);\n\n
 ''' % (idx, q, q, idx)
        g1.write(sql)


del queries[16]
del queries[14]

for idx, q in enumerate(queries):
    with open("q%d.explain.sql" % idx, 'w') as explain, open("q%d.run.sql" % idx, 'w') as run:
        explain.write("explain (costs off) \n%s;\n" % q)
        run.write("explain (analyze, verbose, buffers) \n%s;\n" % q)
