SELECT s.sid, s.serial#, s.username, s.status,
       s.sql_id, s.event, s.wait_class, s.seconds_in_wait
FROM   v$session s
WHERE  s.sql_id = :sql_id;