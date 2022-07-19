set pages 0 lines 300 heading off
select 'drop table '||owner||'.'||table_name||' cascade constraints purge;'
from dba_tables
where owner = upper('&owner')
union all
select 'drop '||object_type||' '||owner||'.'||object_name||';'
from dba_objects
where object_type not in ('TABLE','INDEX','PACKAGE BODY','TRIGGER','LOB')
and object_type not like '%LINK%'
and object_type not like '%PARTITION%'
and owner = upper('&owner')
order by 1;
--select object_type,count(*) from dba_objects where owner = upper('&&owner') group by object_type;