FROM openjdk:8-jdk-slim

RUN apt-get update && apt-get install -y wget curl

# Installing confd
RUN wget -nv https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -O /bin/confd \
  && chmod a+x /bin/confd
ADD config/conf.d/* /etc/confd/conf.d/
ADD config/templates/* /etc/confd/templates/

ADD functions.sh /functions.sh
RUN chmod a+x /functions.sh

ADD config-entrypoint.sh /config-entrypoint.sh
RUN chmod a+x /config-entrypoint.sh

ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_USER_NAME hdfs

ENTRYPOINT ["/config-entrypoint.sh"]
