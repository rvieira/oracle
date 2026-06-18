SELECT
    begin_interval_time,
    end_interval_time,
    MAX(
        (s.phyrds_delta + s.phywrts_delta) /
        ((EXTRACT(DAY    FROM snap_elapsed) * 86400) +
         (EXTRACT(HOUR   FROM snap_elapsed) * 3600) +
         (EXTRACT(MINUTE FROM snap_elapsed) * 60) +
          EXTRACT(SECOND FROM snap_elapsed))
    ) AS iops
FROM dba_hist_sysmetric_summary m
JOIN dba_hist_snapshot s
  ON m.snap_id = s.snap_id
WHERE s.begin_interval_time BETWEEN
      TO_DATE('31-05-2026 07:00','DD-MM-YYYY HH24:MI')
  AND TO_DATE('31-05-2026 18:00','DD-MM-YYYY HH24:MI')
GROUP BY begin_interval_time, end_interval_time
ORDER BY iops DESC;