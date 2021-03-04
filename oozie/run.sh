#!/bin/bash
hdfs dfs -test -d /user/root/share/lib
RESULT=$?
if [[ "$RESULT" -ne "0" ]]; then
    oozie-setup.sh sharelib create -fs ${CONF_CORE_fs_defaultFS}
fi
oozied.sh run
