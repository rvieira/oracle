dgmgrl / "edit database 'standby_db_unique_name' set state='apply-off';"
# Open standby...
sqlplus / as sysdba << EOF
ALTER DATABASE OPEN;
EOF
# Re-enable apply:
dgmgrl / "edit database 'standby_db_unique_name' set state='apply-on';"
