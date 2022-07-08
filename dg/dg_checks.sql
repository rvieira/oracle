-- standby
select protection _mode, protection level from v$database;
select group#, sequence#, bytes, used, archived, status from v$standby_log;
select group#, thread#, sequence#, bytes, archived, status from v$log;

--Primary
select protection mode, protection level from v$database;
select dest _id, status, error from v$archive dest;
