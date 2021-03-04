#!/bin/bash

case $1 in
    spark)
        shift
        case $1 in
            historyserver)
                shift
                hdfs dfs -mkdir $CONF_SPARK_spark_history_fs_logDirectory
                exec spark-class org.apache.spark.deploy.history.HistoryServer $@
                ;;
            submit)
                shift
                exec spark-submit $@
                ;;
            shell)
                shift
                exec spark-shell $@
                ;;
            cleanyarn)
                hdfs dfs -rm -R /user/spark/share/lib
                ;;
            prepareyarn)
                hdfs dfs -test -d /user/spark/share/lib
                RESULT=$?
                echo $RESULT
                if [[ "$RESULT" -ne "0" ]]; then
                    hdfs dfs -mkdir -p /user/spark/share/lib
                    apt-get install -y zip
                    cd $SPARK_HOME/jars && zip jars.zip *
                    hdfs dfs -put $SPARK_HOME/jars/jars.zip /user/spark/share/lib/spark.zip
                    rm -rf $SPARK_HOME/jars/jars.zip
                fi
                echo spark.yarn.archive=hdfs://${CONF_HDFS_fs_defaultFS}/user/spark/share/lib/spark.zip >> $SPARK_HOME/conf/spark-defaults.conf
                ;;
            *)
                export CLASSPATH="$(hadoop classpath):${SPARK_HOME}/jars/*"
                exec $@
                ;;
        esac
        ;;
    *)
        exec $@
        ;;
esac




