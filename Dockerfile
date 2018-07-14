FROM openjdk:8-jre-alpine

LABEL name="zookeeper" version=3.4.12

RUN apk add --no-cache wget bash tar \
    && mkdir -p /opt/zookeeper \
    && wget -q -O - http://www-us.apache.org/dist/zookeeper/zookeeper-3.4.12/zookeeper-3.4.12.tar.gz \
      | tar -xzC /opt/zookeeper --strip-components=1 \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper \
    && echo "alias ll=\"ls -al --color=auto\"" > ~/.profile \
    && echo "PS1=\"[\[\033[32m\]\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\]@\[\033[1;36m\]\h\[\033[1;33m\] \$(/usr/bin/tty | /bin/sed -e 's:/dev/::') -> \[\033[0m\]\"" >> ~/.profile && chmod a+rwx ~/.profile \
    && mkdir /opt/kafka \
    && wget -qO- http://www-us.apache.org/dist/kafka/1.1.0/kafka_2.11-1.1.0.tgz | tar -xzC /opt/kafka --strip-components=1 



EXPOSE 2181 2888 3888

# WORKDIR /opt/zookeeper

# Only checks if server is up and listening, not quorum. 
# See https://zookeeper.apache.org/doc/r3.4.10/zookeeperAdmin.html#sc_zkCommands
# HEALTHCHECK CMD [ $(echo ruok | nc 127.0.0.1:2181) == "imok" ] || exit 1

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

# ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD /opt/zookeeper/bin/zkServer.sh start && /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties 

