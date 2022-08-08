set pages 999

col c1 heading 'owner' for a15
col c2 heading 'name' for a40
col c3 heading 'type' for a10

ttitle 'Invalid|Objects'

select
    owner c1,
    object_type c3,
    object_name c2
from 
    dba_objects
where 
    status != 'VALID'
order by
    owner,
    object_type;