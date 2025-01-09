-- Last 50 analyzed tables:
  1  select * from (
  2  SELECT table_name, last_analyzed
  3  FROM dba_tables
  4  where owner = 'SCOTT' and temporary = 'N'
  5  order by last_analyzed desc
  6  )
  7* where rownum <= 50;
-- Last 50 analyzed indexes:
  1  select * from (
  2  SELECT index_name, last_analyzed
  3  FROM dba_indexes
  4  where owner = 'SCOTT' and temporary = 'N' and last_analyzed is not null
  5  order by last_analyzed desc
  6  )
  7* where rownum <= 50;