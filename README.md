# Hadoop

## Versions

### Hadoop - 2.10.1 (stable)
hdfs + yarn

### Spark - 2.4.8 (latest)

Basic
```bash
docker run -it --rm --net=hadoop_default \
  -p 4050:4040 \
  -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
  -e CONF_YARN_yarn_resourcemanager_hostname=resourcemanager \
  batou9150/spark spark-shell --master yarn
```

With log (for spark history)
```bash
docker run -it --rm --net=hadoop_default \
  -p 4050:4040 \
  -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
  -e CONF_YARN_yarn_resourcemanager_hostname=resourcemanager \
  -e CONF_SPARK_spark_eventLog_enabled=true \
  -e CONF_SPARK_spark_eventLog_dir=hdfs://namenode:8020/logs \
  batou9150/spark spark-shell --master yarn
```

Prepare Yarn : deploy spark jars to HDFS
```bash
docker run -it --rm --net=hadoop_default \
  -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
  -e CONF_YARN_yarn_resourcemanager_hostname=resourcemanager \
  batou9150/spark spark prepareyarn
```

### Hive - 2.3.8

* Java 1.7 or 1.8
* Hadoop 1.x, 2.x, 3.x (3.x required for Hive 3.x)

### Oozie - 5.2.1

* Unix (tested in Linux and Mac OS X)
* Java 1.8+
* Hadoop (tested with 1.2.1 & 2.6.0+) (Support for Hadoop 3 might come in 5.2.0 - dependencies with Hive and Pig)
* ExtJS  2.2 library (optional, to enable Oozie webconsole)

## Usage with Docker

```bash
docker network create hadoop
```

### HDFS
#### Namenode
```bash
docker run -d --name namenode --net hadoop -p 8020:8020 -p 50070:50070 \
    -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
    -e CONF_HDFS_dfs_namenode_http___bind___host=0.0.0.0 \
    -e CONF_HDFS_dfs_namenode_https___bind___host=0.0.0.0 \
    -e CONF_HDFS_dfs_namenode_rpc___bind___host=0.0.0.0 \
    -e CONF_HDFS_dfs_namenode_servicerpc___bind___host=0.0.0.0 \
    -e CONF_HDFS_dfs_client_use_datanode_hostname=true \
    batou9150/hadoop hdfs namenode
```
#### Datanode
```bash
docker run -d --name datanode --net hadoop -p 50010:50010 -p 50020:50020 -p 50075:50075 \
    -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
    batou9150/hadoop hdfs datanode
```

### YARN
#### Resource Manager
```bash
docker run -d --name resourcemanager --net hadoop -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8088:8088 \
    -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
    batou9150/hadoop yarn resourcemanager
```
#### Node Manager
```bash
docker run -d --name nodemanager --net hadoop -p 7337:7337 -p 8040:8040 -p 8041:8041 -p 8042:8042 -p 8048:8048 -p 4040-4049:4040-4049 \
    -e CONF_CORE_fs_defaultFS=hdfs://namenode:8020 \
    -e CONF_YARN_yarn_resourcemanager_hostname=resourcemanager \
    -e CONF_YARN_yarn_nodemanager_pmem___check___enabled=false \
    -e CONF_YARN_yarn_nodemanager_vmem___check___enabled=false \
    -e CONF_YARN_yarn_nodemanager_aux___services=spark_shuffle,mapreduce_shuffle \
    -e CONF_YARN_yarn_nodemanager_aux___services_mapreduce__shuffle_class=org.apache.hadoop.mapred.ShuffleHandler \
    -e CONF_YARN_yarn_nodemanager_aux___services_spark__shuffle_class=org.apache.spark.network.yarn.YarnShuffleService \
    batou9150/hadoop yarn nodemanager
```

