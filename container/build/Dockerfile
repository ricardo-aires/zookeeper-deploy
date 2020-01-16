# FROM gcr.io/gcp-runtimes/centos7
FROM openjdk:8

ARG MIRROR=http://apache-mirror.rbc.ru/pub/apache/zookeeper
ARG VERSION=3.5.6
ARG SHORT_DISTRO_NAME=zookeeper-$VERSION
ARG DISTRO_NAME=apache-$SHORT_DISTRO_NAME-bin

ENV ZOOCFGDIR=/conf \
    ZOODATADIR=/data \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60 \
    ZK_SERVER_HEAP=1024 \
    PATH=$PATH:/$DISTRO_NAME/bin 

RUN set -eux && \
    groupadd -r zookeeper --gid=1000 && \
    useradd -r -g zookeeper --uid=1000 zookeeper && \
    mkdir -p "$ZOODATADIR" "$ZOOCFGDIR" && \
    chown zookeeper:zookeeper "$ZOODATADIR" "$ZOOCFGDIR"

RUN set -eux && \
    wget "$MIRROR/$SHORT_DISTRO_NAME/$DISTRO_NAME.tar.gz" -O "$DISTRO_NAME.tar.gz" && \
	tar xvzf "$DISTRO_NAME.tar.gz" && \
    mv "$DISTRO_NAME/conf/"* "$ZOOCFGDIR" && \
    rm -rf  "$DISTRO_NAME.tar.gz" && \
    chown -R zookeeper:zookeeper "/$DISTRO_NAME"

WORKDIR $DISTRO_NAME
VOLUME ["$ZOODATADIR"]

EXPOSE 2181 2888 3888 8080

USER zookeeper
COPY --chown=zookeeper:zookeeper docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]
