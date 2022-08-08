set lines 500 pages 100
col name for a25
col value for a50

SELECT INST_ID, name, value 
FROM gv$parameter
WHERE name IN 
  ('db_name','db_unique_name','log_archive_format','remote_login_passwordfile','log_archive_config','log_archive_dest_1','log_archive_dest_2',
  'log_archive_dest_3','log_archive_dest_state_1','log_archive_dest_state_2','log_archive_dest_state_3','log_archive_max_processes','db_file_name_convert','log_file_name_convert','standby_file_management') 
order by name, inst_id;