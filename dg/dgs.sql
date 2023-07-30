set linesize 2000
set pagesize 2000
column name format a30 wrap
column value format a50 wrap

-- Standby database parameters
SELECT INST_ID, name, value FROM gv$parameter
WHERE name IN 
  ('db_name','db_unique_name','log_archive_format','remote_login_passwordfile','log_archive_config','log_archive_dest_1','log_archive_dest_2',
  'log_archive_dest_3','log_archive_dest_state_1','log_archive_dest_state_2','log_archive_dest_state_3','log_archive_max_processes','db_file_name_convert','log_file_name_convert','standby_file_management') 
order by name, inst_id;

-- Standby Database Status
column INST_ID format 9;
column NAME format a22 wrap
column VALUE format a30 wrap
column UNIT format a30 wrap
column TIME_COMPUTED format a30 wrap
column DATUM_TIME format a30 wrap
select INST_ID,db_unique_name,name,database_role,open_mode,switchover_status from gv$database;
select INST_ID,NAME,value,UNIT,TIME_COMPUTED,DATUM_TIME from gv$dataguard_stats;
SELECT INST_ID,dest_id,status,database_mode,recovery_mode FROM gv$archive_dest_status WHERE status <> 'INACTIVE';
SELECT INST_ID,PROCESS,STATUS,SEQUENCE# FROM GV$MANAGED_STANDBY;
select PROCESS, CLIENT_PROCESS, THREAD#, SEQUENCE#, BLOCK# from gv$managed_standby where process = 'MRPO' or client_process='LGWR';
