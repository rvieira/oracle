COLUMN name FORMAT A30
COLUMN network_name FORMAT A30

SELECT name,
       network_name
FROM   dba_services
ORDER BY 1;