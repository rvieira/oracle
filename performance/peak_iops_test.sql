-- Test cases for peak_iops.sql
-- Uses CTEs to simulate dba_hist_sysmetric_summary rows without requiring live AWR data.
-- Each test block asserts an expected result using CASE/DECODE; any row returned with
-- status = 'FAIL' indicates a broken assertion.
--
-- Run all blocks in sequence in any Oracle 12c+ session that has SELECT on
-- dba_hist_sysmetric_summary (or replace the WITH clause with the real table).

-- ---------------------------------------------------------------------------
-- Helper: simulated source data used across all tests
-- Columns mirror dba_hist_sysmetric_summary: begin_time, end_time, metric_name, maxval
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- TEST 1: Basic aggregation – two metrics in one window
--   Expect: max_read_iops=100, max_write_iops=50, max_total_iops=150
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-01 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-01 01:00:00' AS end_time,
           'Physical Read Total IO Requests Per Sec'  AS metric_name,
           100 AS maxval FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-01 00:00:00',
           TIMESTAMP '2026-07-01 01:00:00',
           'Physical Write Total IO Requests Per Sec',
           50  FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 1: Basic aggregation' AS test_name,
    CASE WHEN max_read_iops  = 100
          AND max_write_iops = 50
          AND max_total_iops = 150
         THEN 'PASS' ELSE 'FAIL' END AS status,
    max_read_iops,
    max_write_iops,
    max_total_iops
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 2: Only read metric present (no write row for the window)
--   Expect: max_read_iops=200, max_write_iops=NULL, max_total_iops=200
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-02 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-02 01:00:00' AS end_time,
           'Physical Read Total IO Requests Per Sec' AS metric_name,
           200 AS maxval FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 2: Read-only window' AS test_name,
    CASE WHEN max_read_iops  = 200
          AND max_write_iops IS NULL
          AND max_total_iops = 200
         THEN 'PASS' ELSE 'FAIL' END AS status,
    max_read_iops,
    max_write_iops,
    max_total_iops
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 3: Only write metric present (no read row for the window)
--   Expect: max_read_iops=NULL, max_write_iops=75, max_total_iops=75
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-03 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-03 01:00:00' AS end_time,
           'Physical Write Total IO Requests Per Sec' AS metric_name,
           75 AS maxval FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 3: Write-only window' AS test_name,
    CASE WHEN max_read_iops IS NULL
          AND max_write_iops = 75
          AND max_total_iops = 75
         THEN 'PASS' ELSE 'FAIL' END AS status,
    max_read_iops,
    max_write_iops,
    max_total_iops
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 4: Ordering – highest total_iops appears first
--   Window A: read=300, write=100 → total=400
--   Window B: read=50,  write=30  → total=80
--   Expect: first row has max_total_iops=400
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-04 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-04 01:00:00' AS end_time,
           'Physical Read Total IO Requests Per Sec'  AS metric_name,
           300 AS maxval FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-04 00:00:00',
           TIMESTAMP '2026-07-04 01:00:00',
           'Physical Write Total IO Requests Per Sec', 100 FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-05 00:00:00',
           TIMESTAMP '2026-07-05 01:00:00',
           'Physical Read Total IO Requests Per Sec',  50  FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-05 00:00:00',
           TIMESTAMP '2026-07-05 01:00:00',
           'Physical Write Total IO Requests Per Sec', 30  FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 4: Ordering DESC by max_total_iops' AS test_name,
    CASE WHEN max_total_iops = 400 THEN 'PASS' ELSE 'FAIL' END AS status,
    max_read_iops,
    max_write_iops,
    max_total_iops
FROM result
FETCH FIRST 1 ROW ONLY;

-- ---------------------------------------------------------------------------
-- TEST 5: FETCH FIRST 20 ROWS – result set is capped at 20 rows
--   Insert 25 distinct time windows; expect exactly 20 rows returned.
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-01 00:00:00' + (NUMTODSINTERVAL(n, 'HOUR')) AS begin_time,
           TIMESTAMP '2026-07-01 01:00:00' + (NUMTODSINTERVAL(n, 'HOUR')) AS end_time,
           'Physical Read Total IO Requests Per Sec' AS metric_name,
           n * 10 AS maxval
    FROM (
        SELECT LEVEL - 1 AS n FROM DUAL CONNECT BY LEVEL <= 25
    )
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 5: Result capped at 20 rows' AS test_name,
    CASE WHEN COUNT(*) = 20 THEN 'PASS' ELSE 'FAIL' END AS status,
    COUNT(*) AS row_count
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 6: Date filter – rows older than 1 month are excluded
--   Two windows: one within last month, one 2 months ago.
--   The query filters WHERE begin_time >= ADD_MONTHS(SYSDATE,-1).
--   Only the recent window should appear.
-- ---------------------------------------------------------------------------
WITH src AS (
    -- Recent window (within last month)
    SELECT ADD_MONTHS(SYSDATE, 0) - 7 AS begin_time,
           ADD_MONTHS(SYSDATE, 0) - 7 + (1/24) AS end_time,
           'Physical Read Total IO Requests Per Sec'  AS metric_name,
           500 AS maxval FROM DUAL
    UNION ALL
    SELECT ADD_MONTHS(SYSDATE, 0) - 7,
           ADD_MONTHS(SYSDATE, 0) - 7 + (1/24),
           'Physical Write Total IO Requests Per Sec',
           200 FROM DUAL
    UNION ALL
    -- Old window (2 months ago – should be filtered out)
    SELECT ADD_MONTHS(SYSDATE, -2) AS begin_time,
           ADD_MONTHS(SYSDATE, -2) + (1/24) AS end_time,
           'Physical Read Total IO Requests Per Sec',
           999 FROM DUAL
    UNION ALL
    SELECT ADD_MONTHS(SYSDATE, -2),
           ADD_MONTHS(SYSDATE, -2) + (1/24),
           'Physical Write Total IO Requests Per Sec',
           999 FROM DUAL
),
filtered_src AS (
    SELECT * FROM src
    WHERE begin_time >= ADD_MONTHS(SYSDATE, -1)
      AND metric_name IN (
            'Physical Read Total IO Requests Per Sec',
            'Physical Write Total IO Requests Per Sec'
          )
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM filtered_src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 6: Date filter excludes rows older than 1 month' AS test_name,
    CASE WHEN COUNT(*) = 1
          AND MAX(max_total_iops) = 700
         THEN 'PASS' ELSE 'FAIL' END AS status,
    COUNT(*) AS row_count,
    MAX(max_total_iops) AS peak_total
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 7: Decimal precision – ROUND to 2 decimal places
--   read maxval=10.567, write maxval=5.123 → total=15.690
--   Expect: max_read_iops=10.57, max_write_iops=5.12, max_total_iops=15.69
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-06 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-06 01:00:00' AS end_time,
           'Physical Read Total IO Requests Per Sec'  AS metric_name,
           CAST(10.567 AS NUMBER(10,3)) AS maxval FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-06 00:00:00',
           TIMESTAMP '2026-07-06 01:00:00',
           'Physical Write Total IO Requests Per Sec',
           CAST(5.123 AS NUMBER(10,3)) FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 7: Decimal ROUND(x,2)' AS test_name,
    CASE WHEN max_read_iops  = 10.57
          AND max_write_iops = 5.12
          AND max_total_iops = 15.69
         THEN 'PASS' ELSE 'FAIL' END AS status,
    max_read_iops,
    max_write_iops,
    max_total_iops
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 8: Multiple windows – correct GROUP BY (each window independent)
--   Window A: read=100, write=200 → total=300
--   Window B: read=400, write=50  → total=450
--   Expect 2 rows; top row has max_total_iops=450
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-07 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-07 01:00:00' AS end_time,
           'Physical Read Total IO Requests Per Sec'  AS metric_name,
           100 AS maxval FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-07 00:00:00',
           TIMESTAMP '2026-07-07 01:00:00',
           'Physical Write Total IO Requests Per Sec', 200 FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-08 00:00:00',
           TIMESTAMP '2026-07-08 01:00:00',
           'Physical Read Total IO Requests Per Sec',  400 FROM DUAL
    UNION ALL
    SELECT TIMESTAMP '2026-07-08 00:00:00',
           TIMESTAMP '2026-07-08 01:00:00',
           'Physical Write Total IO Requests Per Sec', 50  FROM DUAL
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 8: Multiple windows grouped independently' AS test_name,
    CASE WHEN COUNT(*) = 2
          AND MAX(max_total_iops) = 450
          AND MIN(max_total_iops) = 300
         THEN 'PASS' ELSE 'FAIL' END AS status,
    COUNT(*) AS window_count,
    MAX(max_total_iops) AS top_total,
    MIN(max_total_iops) AS bottom_total
FROM result;

-- ---------------------------------------------------------------------------
-- TEST 9: Metric name filter – unrelated metrics are excluded
--   One row with a different metric_name should produce no output rows.
-- ---------------------------------------------------------------------------
WITH src AS (
    SELECT TIMESTAMP '2026-07-09 00:00:00' AS begin_time,
           TIMESTAMP '2026-07-09 01:00:00' AS end_time,
           'Some Other Metric' AS metric_name,
           9999 AS maxval FROM DUAL
),
filtered_src AS (
    SELECT * FROM src
    WHERE metric_name IN (
            'Physical Read Total IO Requests Per Sec',
            'Physical Write Total IO Requests Per Sec'
          )
),
inner_q AS (
    SELECT
        begin_time,
        end_time,
        CASE WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
             THEN maxval END AS read_iops,
        CASE WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
             THEN maxval END AS write_iops,
        SUM(maxval) OVER (PARTITION BY begin_time, end_time) AS total_iops
    FROM filtered_src
),
result AS (
    SELECT
        begin_time,
        end_time,
        ROUND(MAX(read_iops),  2) AS max_read_iops,
        ROUND(MAX(write_iops), 2) AS max_write_iops,
        ROUND(MAX(total_iops), 2) AS max_total_iops
    FROM inner_q
    GROUP BY begin_time, end_time
    ORDER BY max_total_iops DESC
    FETCH FIRST 20 ROWS ONLY
)
SELECT
    'TEST 9: Unrelated metric names excluded' AS test_name,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status,
    COUNT(*) AS row_count
FROM result;
