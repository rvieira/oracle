et lines 2000 pages 2000
col name for a30 wrap
col value for a50 wrap
col destination for a40 wrap
col status for a10 wrap
col error for a20 wrap
select inst_id,db_unique_name,database_role,open_mode,switchover_status from gv$database;
select inst_id,dest_id,status,database_mode,recovery_mode,destination,error,archived_thread#,archived_seq# from gv$archive_dest_status where status <> 'INACTIVE';