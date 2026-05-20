# oracle

This is a repo for small scripts, queries and configuration files used for Oracle daily DBA activies

## RAC

- Check services registered in SCAN listeners: `rac/check_scan_listener_services.sh`
  - Example: `rac/check_scan_listener_services.sh --all --expect myservice`
