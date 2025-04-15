#!/bin/bash

HOST_LIST="$1"
STATIC_RELEASE="2.6.2.0"
STAGE_DIR="/tmp/dbaasR2/lib/${STATIC_RELEASE}"
ORACLE_HOME=$(grep -s "CIs_home=" /etc/oracle/olr.loc | cut -d "=" -f2)

for host in $(cat "$HOST_LIST"); do
    emcli execute_hosted -cmd="hostname" -credential_set_name="GridHostCreds" -targets="${host}:host" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$host) OK"
    else
        echo "$host) NOK"
    fi
done