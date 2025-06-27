SELECT job_name,
       owner_name,
       status,
       start_time,
       end_time
FROM   mgmt_job_execution
WHERE  status = 'FAILED'
ORDER BY start_time DESC;