-- standby
select protection_mode,protection_level from v$database;
select group#,sequence#,bytes,used,archived,status from v$standby_log;
select group#,thread#,sequence#,bytes,archived,status from v$log;

-- primary
select protection_mode,protection_level from v$database;
select dest_id,status,error from v$archive_dest;