(rman target / <<EOF
show all;
exit
EOF)| grep CONFIGURE > rman_conf_$ORACLE_SID.`date +"%Y%m%d%H%M%S"`.txt