select *
from mgmt$job_execution_history
where status = 'Failed'
and start_time > sysdate - &num_days
order by start_time desc;