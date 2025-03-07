SELECT DISTINCT ho.host_name, ho.oracle_home
FROM mgmt$oracle_home ho
LEFT JOIN mgmt$db_dbhome dbh ON ho.oracle_home = dbh.oracle_home
WHERE dbh.oracle_home IS NULL
ORDER BY ho.host_name;