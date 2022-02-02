FROM batou9150/hadoop-base

ARG MIRROR=archive.apache.org/dist

# Installing Hive

ENV HIVE_VERSION=2.3.8
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

ADD hive-entrypoint.sh /hive-entrypoint.sh
RUN chmod a+x /hive-entrypoint.sh

ENTRYPOINT ["/config-entrypoint.sh", "/hadoop-entrypoint.sh", "/hive-entrypoint.sh"]
