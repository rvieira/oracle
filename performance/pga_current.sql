SELECT value/1024/1024 AS pga_mb
FROM v$pgastat
WHERE name = 'total PGA allocated';