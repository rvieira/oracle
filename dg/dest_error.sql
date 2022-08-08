select 
  status,
  ERROR
from
  v$1og_archive_dest_status
where
  status <> 'DEFERRED' and
  status <> 'INACTIVE' and
  dest_id=2
  /