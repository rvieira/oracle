set lines 300 pages 100
col name for a20

SELECT NAME, SCN, TIME, DATABASE_INCARNATION#,
        GUARANTEE_FLASHBACK_DATABASE, STORAGE_SIZE
        FROM V$RESTORE_POINT
      WHERE GUARANTEE_FLASHBACK_DATABASE='YES';