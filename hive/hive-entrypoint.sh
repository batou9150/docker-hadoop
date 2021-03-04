#!/bin/bash

case $1 in
    hive)
        shift
        export HADOOP_CLIENT_OPTS="-Xmx8192m"
        case $1 in
            metastore)
                case $2 in
                    postgres)
                        wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jar -O $HIVE_HOME/lib/postgresql-42.2.5.jar
                        schematool -dbType postgres -initSchema
                        ;;
                    *)
                        schematool -dbType derby -initSchema
                        ;;
                esac
                shift
                shift
                exec hive --service metastore $@
                ;;
            hiveserver2)
                shift
                exec hiveserver2 $@
                ;;
        esac
        ;;
    *)
        exec $@
        ;;
esac