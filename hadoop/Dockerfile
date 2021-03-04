FROM batou9150/hadoop-base

RUN apt-get install -y bc procps

ARG MIRROR=apache.crihan.fr/dist

# Installing Hadoop (HDFS + Mapred + Yarn)
ENV HADOOP_VERSION=2.10.1
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH
ENV PATH $HADOOP_HOME/bin/:$PATH

RUN wget -nv http://${MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz* \
    && ln -s $HADOOP_HOME/etc/hadoop $HADOOP_CONF_DIR \
    && mkdir $HADOOP_HOME/logs \
    && mkdir -p /hadoop/dfs/data

# Spark shuffle for YARN
ENV SPARK_VERSION=2.4.7
ARG SPARK_YARN_SHUFFLE=spark-${SPARK_VERSION}-bin-hadoop2.7/yarn/spark-${SPARK_VERSION}-yarn-shuffle.jar
RUN wget -nv http://${MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -O /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz $SPARK_YARN_SHUFFLE \
    && mv $SPARK_YARN_SHUFFLE $HADOOP_HOME/share/hadoop/yarn/ \
    && rm -rf /tmp/spark.tar.gz spark-${SPARK_VERSION}-bin-hadoop2.7

ADD hadoop-entrypoint.sh /hadoop-entrypoint.sh
RUN chmod a+x /hadoop-entrypoint.sh

RUN useradd -ms /bin/bash hdfs && chown -R hdfs:hdfs $HADOOP_HOME

ENTRYPOINT ["/config-entrypoint.sh", "/hadoop-entrypoint.sh"]
