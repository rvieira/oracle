SELECT
    begin_time,
    end_time,
    ROUND(MAX(read_iops), 2)  AS max_read_iops,
    ROUND(MAX(write_iops), 2) AS max_write_iops,
    ROUND(MAX(total_iops), 2) AS max_total_iops
FROM (
    SELECT
        begin_time,
        end_time,
        CASE
            WHEN metric_name = 'Physical Read Total IO Requests Per Sec'
            THEN maxval
        END AS read_iops,
        CASE
            WHEN metric_name = 'Physical Write Total IO Requests Per Sec'
            THEN maxval
        END AS write_iops,
        SUM(maxval) OVER (
            PARTITION BY begin_time, end_time
        ) AS total_iops
    FROM dba_hist_sysmetric_summary
    WHERE begin_time >= ADD_MONTHS(SYSDATE, -1)
      AND metric_name IN (
            'Physical Read Total IO Requests Per Sec',
            'Physical Write Total IO Requests Per Sec'
      )
)
GROUP BY begin_time, end_time
ORDER BY max_total_iops DESC
FETCH FIRST 20 ROWS ONLY;