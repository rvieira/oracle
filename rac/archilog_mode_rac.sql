srvctl stop database -d RAC
srvctl start database -d RAC -o mount
alter database archivelog;
srvctl stop database -d RAC
srvctl start database -d RAC