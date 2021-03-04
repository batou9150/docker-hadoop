#!/bin/bash

. ./functions.sh

case $1 in
    "")
        exec bash
        ;;
    hdfs)
        case $2 in
            namenode)
                CLUSTER_NAME=${CLUSTER_NAME:-"hadoop"}
                su hdfs -c "$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME -nonInteractive|| true"
                if [ -n "$HA" ]; then
                    su hdfs -c "$HADOOP_HOME/bin/hdfs zkfc -formatZK -nonInteractive || true"
                    su hdfs -c "$HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs start zkfc"
                fi
                exec su hdfs -c "$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode"
                ;;
            datanode)
                datadir=`echo $CONF_HDFS_dfs_datanode_data_dir | sed -e 's#file://##'`
                if [ ! -d $datadir ]; then
                  echo "Datanode data directory not found: $datadir"
                  exit 2
                fi
                exec su hdfs -c "$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode"
                ;;
            *)
                ;;
        esac
        ;;
    mapred)
        shift
        exec $HADOOP_HOME/bin/mapred --config $HADOOP_CONF_DIR $@
        ;;
    yarn)
        if [ $2 == "nodemanager" ]; then
            if [ -z ${CONF_YARN_yarn_nodemanager_resource_memory___mb+x} ]; then
                export CONF_YARN_yarn_nodemanager_resource_memory___mb=`grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024*0.8" | bc | awk '{print int($1)}'`
                addPropertyFromEnv "CONF_YARN_yarn_nodemanager_resource_memory___mb=$CONF_YARN_yarn_nodemanager_resource_memory___mb"
            fi
            if [ -z ${CONF_YARN_yarn_nodemanager_resource_cpu___vcores+x} ]; then
                export CONF_YARN_yarn_nodemanager_resource_cpu___vcores=`cat /proc/cpuinfo | grep processor | wc -l`
                addPropertyFromEnv "CONF_YARN_yarn_nodemanager_resource_cpu___vcores=$CONF_YARN_yarn_nodemanager_resource_cpu___vcores"
            fi
        fi
        shift
        exec su hdfs -c "$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR $@"
        ;;
    *)
        exec $@
        ;;
esac