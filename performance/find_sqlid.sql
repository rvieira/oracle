-- Find SQL_ID(s) for a piece of SQL text (be specific)
SELECT sql_id, child_number, plan_hash_value,
       executions, elapsed_time/1e6 elapsed_s,
       last_active_time
FROM   v$sql
WHERE  sql_text LIKE '%put a distinctive chunk here%'
AND    sql_text NOT LIKE '%v$sql%'
ORDER BY last_active_time DESC;