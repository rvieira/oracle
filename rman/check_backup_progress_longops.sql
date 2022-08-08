set lines 200 pages 100
col totalwork for 999999999999999

select 
    opname,
    start_time,
    sofar,
    totalwork,
    round(sofar/totalwork*100,2) as pct,
    to_char(to_date(time_remaining,'sssss'),'hh24:mi:ss') as time_left
from
    gv$session_longops
where
    opname like 'RMAN%'
    and totalwork != 0
    and sofar != totalwork
order by 
    opname;