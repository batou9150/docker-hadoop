FROM maven:3-jdk-8-slim AS builder

ENV OOZIE_VERSION=5.2.1
ADD http://apache.crihan.fr/dist/oozie/$OOZIE_VERSION/oozie-$OOZIE_VERSION.tar.gz /tmp/oozie.tar.gz
RUN tar -xvf /tmp/oozie.tar.gz  -C /tmp \
    && rm /tmp/oozie.tar.gz*  \
    && cd /tmp/oozie-${OOZIE_VERSION} \
    && mvn clean package assembly:single -DskipTests --batch-mode -Puber -Dhadoop.version=2.8.1 -Dspark.version=2.3.2 -Dspark.scala.binary.version=2.11 -Djackson.version=2.6.5 \
    && tar xf distro/target/oozie-${OOZIE_VERSION}-distro.tar.gz -C /opt \
    && rm -rf /tmp/oozie-${OOZIE_VERSION}


FROM batou9150/spark

ENV OOZIE_VERSION=5.2.1
ENV OOZIE_HOME=/opt/oozie-${OOZIE_VERSION}
ENV PATH=$PATH:${OOZIE_HOME}/bin

ENV CONF_OOZIE_oozie_service_SparkConfigurationService_spark_configurations=*=${SPARK_HOME}/conf
ENV CONF_OOZIE_oozie_service_HadoopAccessorService_hadoop_configurations=*=${HADOOP_CONF_DIR}

ADD http://archive.cloudera.com/gplextras/misc/ext-2.2.zip ${OOZIE_HOME}/libext/
COPY --from=builder ${OOZIE_HOME} ${OOZIE_HOME}
RUN mkdir -p /var/log/oozie \
  && mkdir -p /var/lib/oozie/data \
  && ln -s /var/log/oozie ${OOZIE_HOME}/log \
  && ln -s /var/lib/oozie/data ${OOZIE_HOME}/data \
  && ln -s ${SPARK_HOME}/conf ${OOZIE_HOME}/conf/spark-conf \
  && cp -R ${OOZIE_HOME}/conf/* /etc/hadoop \
  && rm -rf ${OOZIE_HOME}/conf/hadoop-conf \
  && ln -s /etc/hadoop ${OOZIE_HOME}/conf/hadoop-conf

ADD run.sh /run.sh
RUN chmod a+x /run.sh

RUN apt-get install -y unzip

ENTRYPOINT [ "/config-entrypoint.sh", "/hadoop-entrypoint.sh", "/spark-entrypoint.sh" ]

CMD ["/run.sh"]
