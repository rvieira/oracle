SET HEADING ON
SET FEEDBACK OFF
SET PAGESIZE 100
SET LINESIZE 200
COLUMN job_name FORMAT A40
COLUMN status FORMAT A12
COLUMN target_name FORMAT A30
COLUMN execution_start FORMAT A20
COLUMN execution_end FORMAT A20

SELECT j.job_name,
       je.status,
       NVL(t.target_name, 'N/A') AS target_name,
       TO_CHAR(je.execution_start_time, 'YYYY-MM-DD HH24:MI') AS execution_start,
       TO_CHAR(je.execution_end_time, 'YYYY-MM-DD HH24:MI') AS execution_end
FROM   mgmt$job_execution je
JOIN   mgmt$job j ON je.job_id = j.job_id
LEFT JOIN mgmt$target t ON je.target_guid = t.target_guid
WHERE  je.status = 'Failed'
  AND  je.execution_start_time > SYSDATE - 1
ORDER BY je.execution_start_time DESC;