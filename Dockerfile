FROM ubuntu:22.04
MAINTAINER Tarre <tarre@uniguide.se>

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ENV TZ="Europe/Stockholm"

ARG MARIADB_VERSION="mariadb-10.6"
ARG MARIADB_VERSION_CHECKSUM="30d2a05509d1c129dd7dd8430507e6a7729a4854ea10c9dcf6be88964f3fdc25"

ARG WSREP_CLUSTER_NAME
ARG WSREP_SST_DONOR
ARG WSREP_CLUSTER_ADDRESS
ARG WSREP_NODE_NAME
ARG WSREP_NODE_ADDRESS

RUN apt-get update
RUN apt-get install -y  software-properties-common tzdata wget curl
RUN ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN wget https://r.mariadb.com/downloads/mariadb_repo_setup
# This checksum is bound to mariadb-10.6. Remember to change if you switch version
RUN echo "$MARIADB_VERSION_CHECKSUM mariadb_repo_setup" \
    | sha256sum -c -
RUN chmod +x mariadb_repo_setup
RUN ./mariadb_repo_setup \
       --mariadb-server-version="$MARIADB_VERSION" \
RUN apt-get update
RUN apt install --allow-unauthenticated -y mariadb-server mariadb-backup rsync
RUN mkdir /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY galera.cnf /etc/mysql/conf.d/galera.cnf


COPY entry.sh /app/entry.sh
RUN chmod +x /app/entry.sh
RUN sed -i "s|%WSREP_CLUSTER_NAME%|${WSREP_CLUSTER_NAME}|g" /etc/mysql/conf.d/galera.cnf
RUN sed -i "s|%WSREP_SST_DONOR%|${WSREP_SST_DONOR}|g" /etc/mysql/conf.d/galera.cnf
RUN sed -i "s|%WSREP_CLUSTER_ADDRESS%|${WSREP_CLUSTER_ADDRESS}|g" /etc/mysql/conf.d/galera.cnf
RUN sed -i "s|%WSREP_NODE_NAME%|${WSREP_NODE_NAME}|g" /etc/mysql/conf.d/galera.cnf
RUN sed -i "s|%WSREP_NODE_ADDRESS%|${WSREP_NODE_ADDRESS}|g" /etc/mysql/conf.d/galera.cnf

ENTRYPOINT ["sh", "/app/entry.sh"]
