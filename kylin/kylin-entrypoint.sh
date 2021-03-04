#!/bin/bash
case $1 in
    start)
        shift
        start-hbase.sh
        mkdir ${KYLIN_HOME}/logs
        touch ${KYLIN_HOME}/logs/kylin.log
        kylin.sh start
        exec tail -n 1000 -f ${KYLIN_HOME}/logs/kylin.log
        ;;
    sample)
        shift
        exec sample.sh $@
        ;;
    reset)
        shift
        exec metastore.sh reset
        ;;
    backup)
        shift
        metastore.sh backup
        mv $KYLIN_HOME/meta_backups/meta_* $1
        ;;
    restore)
        shift
        exec metastore.sh restore $1
        ;;
    *)
        exec $@
        ;;
esac

