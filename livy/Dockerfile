FROM batou9150/hadoop-base

RUN apt-get install -y unzip

ARG MIRROR=archive.apache.org/dist

# Installing Spark
ENV SPARK_VERSION=2.4.4
ENV SPARK_URL=http://${MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz
ENV SPARK_HOME=/opt/spark-$SPARK_VERSION
RUN wget -nv "$SPARK_URL" -O /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-* $SPARK_HOME \
    && rm -f /tmp/spark.tar.gz

# Installing Livy
ENV LIVY_VERSION=0.7.0-incubating

ENV LIVY_URL=http://${MIRROR}/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip
ENV LIVY_HOME=/opt/livy-$LIVY_VERSION
RUN wget -nv "$LIVY_URL" -O /tmp/livy.zip \
    && unzip /tmp/livy.zip -d /opt/ \
    && rm /tmp/livy.zip \
    && mv /opt/apache-livy-$LIVY_VERSION-bin ${LIVY_HOME} \
    && mkdir ${LIVY_HOME}/logs \
    && ln -s $LIVY_HOME/conf /etc/livy

ENV PATH $SPARK_HOME/bin/:$LIVY_HOME/bin/:$PATH

ADD config/conf.d/* /etc/confd-livy/conf.d/
ADD config/templates/* /etc/confd-livy/templates/

ADD livy-entrypoint.sh /livy-entrypoint.sh
RUN chmod a+x /livy-entrypoint.sh

ENTRYPOINT ["/config-entrypoint.sh", "/livy-entrypoint.sh"]

CMD ["livy-server"]
