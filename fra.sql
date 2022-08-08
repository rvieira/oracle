column NAME format a10
column SPACE_LIMIT_GB format 999999999999999
column SPACE_USED_GB format 999999999999999
column PERCENT_USED format 990.0
column SPACE_FREE_GB format 999999999999999
select 
  NAME,
  round (SPACE_LIMIT/1024/1024/1024) as SPACE_LIMIT_GB,
  round (SPACE_USED/1024/1024/1024) as SPACE_USED_GB,
  round (((SPACE_LIMIT-(SPACE_USED))/1024/1024/1024)) SPACE_FREE_GB
  (round (SPACE_USED/1024/1024/1024))/round(SPACE_LIMIT/1024/1024/1024) * 100 PERCENT_USED
From 
  V$recovery file dest;

BREAK ON REPORT
COMPUTE SUM LABEL "Total %:" OF "SPACE_USED%" "SPACE_RECLAIM%" "NUMBER_OF_FILES" ON REPORT
select FILE_TYPE,PERCENT_SPACE_USED "SPACE_USED%",PERCENT_SPACE_RECLAIMABLE "SPACE_RECLAIM%",NUMBER_OF_FILES
from v$recovery_area_usage;
col SCN format 999999999999999
col NAME format ASO
col STORAGE_SIZE format 999999999999999
col TIME format A30
col STORAGE_SIZE_GB format 999,999.0
SELECT NAME, SCN, TIME, DATABASE_INCARNATION#, GUARANTEE_FLASHBACK_DATABASE, (STORAGE_SIZE/1024/1024/1024) STORAGE_SIZE_GB FROM V$RESTORE_POINT;

set lines 200
set pagesize 500
col DISK_NAME format a30
col group_number heading GROUP|NUMBER
col GROUP_NAME format a10
col path format a40
col PERCENT_USED format 990.0
col TOTAL_GB format 999,990
col FREE_GB format 999,990
col USED_GB format 999,990
select g.name GROUP_NAME,g.group_number,
(total_mb)/1024 TOTAL GB,
(free_mb)/1024 FREE_GB,
((total_mb)-(free_mb))/1024 USED_GB,
((total_mb)-(free_mb))/(total_mb)*100 PERCENT_USED
from v$asm_diskgroup g
where total_mb>0
order by g.name;