set lines 200
col opname for a40

select sid, serial#, opname, sofar, totalwork, round(sofar/totalwork*100,2) complete
from v$session_longops
where totalwork !=0 and sofar != totalwork
order by 1;