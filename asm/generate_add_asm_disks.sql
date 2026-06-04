-- gen_add_asm_disks.sql
-- sqlplus / as sysasm @gen_add_asm_disks.sql

set pages 0 lines 300 trims on feedback off verify off echo off heading off

spool add_asm_disks_generated.sql

prompt -- Review before running.
prompt

select
    'ALTER DISKGROUP ' ||
    case
        when regexp_like(upper(path), '(^|[/_-])DATA[0-9]{1,3}($|[^0-9])') then 'DATA'
        when regexp_like(upper(path), '(^|[/_-])RECO[0-9]{1,3}($|[^0-9])') then 'RECO'
        when regexp_like(upper(path), '(^|[/_-])REDO[0-9]{1,3}($|[^0-9])') then 'REDO'
        else 'UNKNOWN_DG'
    end ||
    ' ADD DISK ''' || path || ''' NAME ' ||
    regexp_substr(upper(path), '(DATA|RECO|REDO)[0-9]{1,3}') ||
    ' REBALANCE POWER 8;'
from v$asm_disk
where header_status in ('PROVISIONED', 'CANDIDATE')
and path is not null
order by path;

prompt
prompt -- Check for UNKNOWN_DG before running.
prompt

spool off

set feedback on heading on
prompt Generated file: add_asm_disks_generated.sql