-- Check existing disk groups
SELECT name, state, type, total_mb, free_mb 
FROM v$asm_diskgroup;

-- Check disks in the group
SELECT group_number, disk_number, name, path, header_status, mount_status 
FROM v$asm_disk;