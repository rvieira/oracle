-- -----------------------------------------------------------------------------------
-- File Name    : blocking.sql
-- Author       : Ricardo Augusto Ripoll Vieira
-- Description  : list blocking sessions
-- Requirements : DBA role
-- Last Modified: 03-DEC-2020
-- -----------------------------------------------------------------------------------
select * from v$session
where blocking_session is not null;


select * from v$session_blockers;
