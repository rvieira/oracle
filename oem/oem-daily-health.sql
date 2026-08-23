PROMPT =========================================================
PROMPT OEM DAILY HEALTH REPORT
PROMPT =========================================================

SELECT SYSDATE AS report_time
FROM dual;

PROMPT
PROMPT --- TARGET COUNTS ---

SELECT target_type,
       COUNT(*) AS target_count
FROM   mgmt$target
GROUP BY target_type
ORDER BY target_count DESC;

PROMPT
PROMPT --- CURRENT ALERTS ---

SELECT severity,
       COUNT(*) AS alert_count
FROM   mgmt$alert_current
GROUP BY severity
ORDER BY alert_count DESC;

PROMPT
PROMPT --- TARGETS NOT UP ---

SELECT t.target_name,
       t.target_type,
       a.availability_status,
       a.start_timestamp
FROM   mgmt$target t
       JOIN mgmt$availability_current a
         ON a.target_guid = t.target_guid
WHERE  UPPER(a.availability_status) NOT IN ('UP', 'TARGET UP')
ORDER BY a.start_timestamp;

PROMPT
PROMPT --- ACTIVE BLACKOUTS ---

SELECT *
FROM   mgmt$blackouts
ORDER BY 1;