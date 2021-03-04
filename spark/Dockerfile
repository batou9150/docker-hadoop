FROM batou9150/hadoop-base

ARG MIRROR=apache.crihan.fr/dist

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION
ENV PATH=$SPARK_HOME/bin:$PATH

RUN wget -nv http://${MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -O /tmp/spark.tar.gz \
    && tar -xf /tmp/spark.tar.gz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-* ${SPARK_HOME} \
    && rm -f /tmp/spark.tar.gz \
    && echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> $SPARK_HOME/conf/spark-env.sh \
    && echo "spark.shuffle.service.enabled   true" >> $SPARK_HOME/conf/spark-defaults.conf \
    && echo "spark.master.rest.enabled       true" >> $SPARK_HOME/conf/spark-defaults.conf

ADD spark-entrypoint.sh /spark-entrypoint.sh
RUN chmod a+x /spark-entrypoint.sh

ENTRYPOINT ["/config-entrypoint.sh", "/hadoop-entrypoint.sh", "/spark-entrypoint.sh"]