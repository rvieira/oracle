SET LINESIZE 200
SET PAGESIZE 200
SELECT group_number, disk_number, name, path, mount_status
FROM v$asm_disk
ORDER BY group_number, disk_number;