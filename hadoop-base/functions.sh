#!/bin/bash

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function addPropertyFromEnv() {
    local envVar=$1

    module=`echo $envVar | sed  -rn 's/CONF_([A-Z]*)_.*/\1/p' | awk '{print tolower($0)}'`
    name=`echo $envVar | sed  -rn 's/CONF_[A-Z]*_([A-Za-z0-9_]*)=.*/\1/p' | sed 's/___/-/g' | sed 's/_/./g' | sed 's/\.\./_/g'` 
    var=`echo $envVar | sed  -rn 's/([A-Z_]*)=.*/\1/p'`
    value=${!var} 
    value=$(echo "$value" | sed 's/,=,/;/g')
    echo "$module - Setting $name=$value"
    if [ "$module" == "spark" ]; then
        if [ -n "$SPARK_HOME" ]; then
            if [ $name == "hive.metastore.uris" ]; then
                resetFile ${SPARK_HOME}/conf/hive-site.xml
                addProperty ${SPARK_HOME}/conf/hive-site.xml $name "$value"
            else
                echo $name $value >> $SPARK_HOME/conf/spark-defaults.conf
            fi
        fi
    elif [ "$module" == "oozie" ]; then
        if [ -n "$OOZIE_HOME" ]; then
            addProperty ${OOZIE_HOME}/conf/oozie-site.xml $name "$value"
        fi
    elif [ "$module" == "hive" ]; then
        if [ -n "$HIVE_HOME" ]; then
            addProperty ${HIVE_HOME}/conf/hive-site.xml $name "$value"
        fi
    else
        addProperty ${HADOOP_CONF_DIR}/$module-site.xml $name "$value"
    fi
}

function resetFile() {
    local file=$1
    echo "Reseting ${file}"
cat <<"EOF" > $file
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
</configuration>
EOF
}

function configure() {
    if [ -n "$ETCD_CONFIG_HOST" ]
    then
        PORT=${ETCD_CONFIG_PORT:-2379}
        HOST=`dig +short ${ETCD_CONFIG_HOST}`

        confd -onetime -backend etcd -node http://${HOST:-$ETCD_CONFIG_HOST}:${PORT}
        . /env.sh
    fi

    if [ -n "$CONSUL_CONFIG_HOST" ]
    then
        PORT=${CONSUL_CONFIG_PORT:-8500}
        HOST=`dig +short ${CONSUL_CONFIG_HOST}`

        confd -onetime -backend consul -node ${HOST:-$CONSUL_CONFIG_HOST}:${PORT}
        . /env.sh
    fi

    if [ -d ${HADOOP_CONF_DIR} ]
    then
        for file in ${HADOOP_CONF_DIR}/*-site.xml; do
            resetFile $file
        done
    else
        mkdir ${HADOOP_CONF_DIR}
        resetFile ${HADOOP_CONF_DIR}/core-site.xml
        resetFile ${HADOOP_CONF_DIR}/hdfs-site.xml
        resetFile ${HADOOP_CONF_DIR}/yarn-site.xml
    fi

    if [ -n "$OOZIE_HOME" ]; then
        resetFile ${OOZIE_HOME}/conf/oozie-site.xml
    fi

    if [ -n "$HIVE_HOME" ]; then
        resetFile ${HIVE_HOME}/conf/hive-site.xml
    fi

    local var
    local value
    cat <<"EOF" > ${HADOOP_CONF_DIR}/capacity-scheduler.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xls"?>
<configuration>
  <property>
    <name>yarn.scheduler.capacity.resource-calculator</name>
    <value>org.apache.hadoop.yarn.util.resource.DominantResourceCalculator</value>
  </property>
  <property>
    <name>yarn.scheduler.capacity.maximum-am-resource-percent</name>
    <value>1</value>
  </property>
  <property>
    <name>yarn.scheduler.capacity.root.queues</name>
    <value>default</value>
  </property>
  <property>
    <name>yarn.scheduler.capacity.root.default.capacity</name>
    <value>100.0</value>
  </property>
  <property>
    <name>yarn.scheduler.capacity.root.default.maximum-capacity</name>
    <value>100.0</value>
  </property>
</configuration>
EOF
    for envVar in `printenv`;do
        if [[ $envVar == CONF_* ]]; then
            addPropertyFromEnv $envVar
        fi
    done
}

function download() {
    if [ ! -z "$DL_REMOTE_PATH" ] ; then
        DL_LOCAL_PATH=${DL_LOCAL_PATH:-/app.jar}
        wget "$DL_REMOTE_PATH" -O ${DL_LOCAL_PATH}
    fi
}
