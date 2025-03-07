EXPLAIN PLAN FOR <your_sql_statement>;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM v$sql_plan WHERE sql_id = 'your_sql_id_here';