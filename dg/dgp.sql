set linesize 2000
set pagesize 2000
column name format a30 wrap
column Value format a50 wrap

-- Database parameters

SELECT INST_ID, name,value FROM gv$parameter
WHERE name IN ( 'db_name', 'db unique name','log _archive_format', 'remote_login_passwordfile', 'log_archive_config' ,'log_archive_dest_1', 'log_archive_dest_2','log_archive_dest_3', 'log_archive_dest_state_1','log_archive_dest_state_2','1og_archive_dest_state_3','log_archive_max_processes','db_file_name_convert', 'log_file_name_convert','standby_file_management') order by name, inst_id;

-- Primary database status

column DESTINATION format a40 wrap
column STATUS format a10 wrap
column ERROR format a20 wrap
-- select INST_ID,db_unique_name,database_role, open_mode, switchover_status from gv$database;
-- SELECT INST_ID,dest_1d, STATUS, database_mode, recovery_mode, DESTINATION, ERROR, ARCHIVED_THREAD, ARCHIVED_SEQ# FROM gV$ARCHIVE_DEST_STATUS WHERE STATUS «> 'INACTIVE" ;

column role format a7 tru
column name format a10 wrap
column force_logging format a13 tru
column remote_archive format a14 tru
column dataguard_broker format a16 tru
column supp_log_pk format a11 tru
column supp_log_u1 format a11 tru
select INST_ID, name,database_role role, log_mode, protection_mode, protection_level, open_mode, force_logging, remote_archive, switchover_status, dataguard_broker, supplemental_log_data_pk supp_log_pk, supplemental_log_data_ui supp_log_ui from gv$database;
SELECT INST_ID,dest_id, STATUS, database_mode, recovery_mode, DESTINATION, ERROR, ARCHIVED_THREAD#, ARCHIVED_SEQ# FROM gV$ARCHIVE_DEST_STATUS WHERE STATUS <> 'INACTIVE';