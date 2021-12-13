-- -----------------------------------------------------------------------------------
-- File Name    : audit-trail.sql
-- Author       : Ricardo Augusto Ripoll Vieira
-- Description  : List contents of dba_audit_trail until today for user &username
-- Requirements : DBA role
-- Last Modified: 2018
-- -----------------------------------------------------------------------------------
select os_username,userhost,owner,action_name,extended_timestamp
from dba_audit_trail
where timestamp > to_date('03-JUL-19 22.00.00','dd-mon-yy hh24.mi.ss') and current_user='&username'
/
