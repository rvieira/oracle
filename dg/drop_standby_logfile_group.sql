set lines 200 pages 200
set head off 
select distinct text from (select 'alter database add standby logfile thread '||thread#||' group '||group#||' size '||bytes||';' text from gv$standby_log order by thread#,group#) order by 1;
select distinct text from (select 'alter database drop standby logfile group '||group#||';' text from gv$standby_log order by thread#,group#) order by 1;
