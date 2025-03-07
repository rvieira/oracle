SELECT s.sid, s.serial#, s.username, t.start_time, t.xid, t.status, s.sql_id
FROM v$transaction t
JOIN v$session s ON t.ses_addr = s.saddr
ORDER BY t.start_time;

SELECT sql_text 
FROM v$sql 
WHERE sql_id = '&sql_id';

SELECT blocking_session, sid, serial#, wait_class, seconds_in_wait 
FROM v$session 
WHERE blocking_session IS NOT NULL;

SELECT o.object_name, o.object_type, l.session_id, l.locked_mode 
FROM v$locked_object l
JOIN dba_objects o ON l.object_id = o.object_id;