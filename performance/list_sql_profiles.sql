set lines 300 pages 100
col category for a20
col sql_text for a40
col sql_text for a100

select name,sql_text,category,status from dba_sql_profiles;