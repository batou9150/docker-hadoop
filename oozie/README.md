# oozie

## commands

### Push oozie share libraries to HDFS cluster
oozie-setup.sh sharelib create -fs ${CONF_CORE_fs_defaultFS}

#### Spark custom sharelib
```bash
export OOZIE_SHARE_LIB_DIR=/user/<username>/share/lib/lib_<ts>
hdfs dfs -mkdir ${OOZIE_SHARE_LIB_DIR}/spark2
hdfs dfs -cp ${OOZIE_SHARE_LIB_DIR}/spark/oozie-sharelib-spark-*.jar ${OOZIE_SHARE_LIB_DIR}/spark2/
hdfs dfs -put ${SPARK_HOME}/jars/* ${OOZIE_SHARE_LIB_DIR}/spark2/
hdfs dfs -put ${SPARK_HOME}/conf/hive-site.xml ${OOZIE_SHARE_LIB_DIR}/spark2/
hdfs dfs -put ${SPARK_HOME}/python/lib/py* ${OOZIE_SHARE_LIB_DIR}/spark2/
oozie admin -oozie http://localhost:11000/oozie -sharelibupdate
```

Check the configuration
`oozie admin -oozie http://localhost:11000/oozie -shareliblist spark2`

Add `oozie.action.sharelib.for.spark=spark2` to the job.properties

### Init database
oozie-setup.sh db create -run

### Start oozie foreground
oozied.sh run

## test build with diffrent versions

```sh
bin/mkdistro.sh -DskipTests -Puber # OK

bin/mkdistro.sh -DskipTests -Puber -Dhadoop.version=2.8.1 # OK
bin/mkdistro.sh -DskipTests -Puber -Dhadoop.version=2.8.2 # KO
bin/mkdistro.sh -DskipTests -Puber -Dhadoop.version=2.8.3 # KO
bin/mkdistro.sh -DskipTests -Puber -Dhadoop.version=2.8.4 # KO

bin/mkdistro.sh -DskipTests -Puber -Dhadoop.version=2.9.1 # KO

bin/mkdistro.sh -DskipTests -Puber -Dspark.version=2.2.0 -Dspark.scala.binary.version=2.11 # OK
bin/mkdistro.sh -DskipTests -Puber -Dspark.version=2.2.1 -Dspark.scala.binary.version=2.11 # OK
bin/mkdistro.sh -DskipTests -Puber -Dspark.version=2.3.0 -Dspark.scala.binary.version=2.11 # OK

bin/mkdistro.sh -DskipTests -Puber -Dhive.version=2.1.1 # KO
```
