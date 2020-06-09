import sys
import re


with open('normal.log') as n, open('patched.log') as p:
    normal_txt = n.read()
    patched_txt = p.read()

normal_exec_tm = [float(i) for i in re.findall('Execution Time: (\d+.\d+) ms', normal_txt)]
patched_exec_tm = [float(i) for i in re.findall('Execution Time: (\d+.\d+) ms', patched_txt)]

for idx, tm in enumerate(normal_exec_tm):
    tm_p = patched_exec_tm[idx]
    print("Query-%2d Normal: %10s Patched: %10s Improve %10s %s" %
          (idx+1, tm, tm_p,  round((tm - tm_p) / tm * 100, 2), '%'))
