FROM batou9150/spark

ARG MIRROR=apache.crihan.fr/dist

# Installing Hive
ENV HIVE_VERSION=2.3.6
ENV HIVE_HOME=/opt/hive-$HIVE_VERSION
ENV HIVE_LIB=$HIVE_HOME/lib
ENV HCAT_HOME=$HIVE_HOME/hcatalog
ENV HIVE_CONF_DIR=/etc/hive/conf
RUN wget -nv http://${MIRROR}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz -O /tmp/hive.tar.gz \
    && tar -xvf /tmp/hive.tar.gz -C /opt \
    && mv /opt/apache-hive-$HIVE_VERSION-* $HIVE_HOME \
    && rm -f /tmp/hive.tar.gz \
    && mkdir /etc/hive \
    && ln -s $HIVE_HOME/conf $HIVE_CONF_DIR \
    && cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml
ENV PATH $HIVE_HOME/bin:$HCAT_HOME/bin:$PATH

# Installing HBase
ARG HBASE_VERSION=1.4.11
ENV HBASE_HOME=/opt/hbase-$HBASE_VERSION
RUN wget -nv http://${MIRROR}/hbase/hbase-${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz -O /tmp/hbase.tar.gz \
    && tar -xvf /tmp/hbase.tar.gz -C /opt \
    && rm -f /tmp/hbase.tar.gz

# Installing Kylin
ARG KYLIN_VERSION=2.6.4
ENV KYLIN_HOME=/opt/kylin-$KYLIN_VERSION
RUN wget -nv http://${MIRROR}/kylin/apache-kylin-${KYLIN_VERSION}/apache-kylin-${KYLIN_VERSION}-bin-hbase1x.tar.gz -O /tmp/kylin.tar.gz \
    && tar -xvf /tmp/kylin.tar.gz -C /opt \
    && mv /opt/apache-kylin-$KYLIN_VERSION-* $KYLIN_HOME \
    && rm -f /tmp/kylin.tar.gz

# Setting the PATH environment variable
ENV PATH=$PATH:$HBASE_HOME/bin:$KYLIN_HOME/bin

ADD kylin-entrypoint.sh /kylin-entrypoint.sh
RUN chmod a+x /kylin-entrypoint.sh

ENTRYPOINT ["/config-entrypoint.sh", "/hadoop-entrypoint.sh", "/kylin-entrypoint.sh"]
