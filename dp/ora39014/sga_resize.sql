set lines 200
col component format a20
col initial_size format 999,999,999,999
col finish_size format 999,999,999,999
col target_size format 999,999,999,999

select to_char(end_time, 'dd-MON-yyyy hh24:mi:ss') end_time,
component, initial_size, target_size,
final_size, status
from v$sga_resize_ops
order by end_time;