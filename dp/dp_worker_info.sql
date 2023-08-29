set lines 150 pages 100 numwidth 7
col program for a38
col username for a10
col spid for a7
select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') "DATE", s.program, s.sid, s.status, s.username, d.job_name, p.spid, s.serial#, p.pid
from v$session s, v$process p, dba_datapump_sessions d
where p.addr=s.paddr and s.saddr=d.saddr;