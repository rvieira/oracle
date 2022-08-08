set lines 2000 pages 2000
col INST_ID for 99
col archived for a8
col status for a10
col group# for 99
col thread# for 99
col sequence# for 999999999999999
col member for a80

-- Database Redo Logs
select a.thread#,a.group#,a.archived,a.sequence#,a.bytes,a.first_change#,a.first_time,a.status,b.member
from v$log a, v$logfile b
where b.group#=a.group#
order by a.thread#,a.group#;

-- Database Standby Redo Logs
select a.thread#,a.group#,a.archived,a.sequence#,a.bytes,a.first_change#,a.first_time,a.status,b.member
from v$standby_log a, v$logfile b
where b.group#=a.group#
order by a.thread#,a.group#;