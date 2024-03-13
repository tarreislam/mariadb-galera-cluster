FROM ubuntu:22.04
MAINTAINER Tarre <tarre@uniguide.se>

WORKDIR /app

ENV DEBIAN_FRONTEND noninteractive
ENV TZ="Europe/Stockholm"

# Currently the latest LTS @2024-03-11: https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/
ARG MARIADB_VERSION="mariadb-10.11"

RUN apt-get update
RUN apt-get install -y  software-properties-common tzdata wget curl
RUN ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN wget https://r.mariadb.com/downloads/mariadb_repo_setup

RUN chmod +x mariadb_repo_setup
RUN ./mariadb_repo_setup \
       --mariadb-server-version="$MARIADB_VERSION" \
RUN apt-get update
RUN apt install --allow-unauthenticated -y mariadb-server mariadb-backup rsync
RUN mkdir /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY galera.cnf /etc/mysql/conf.d/galera.cnf
# Bind address adressed twice because version diff handles it differently
COPY 00-mariadb-server.cnf /etc/mysql/mariadb.conf.d/00-mariadb-server.cnf

COPY entry.sh /app/entry.sh
RUN chmod +x /app/entry.sh


ENTRYPOINT ["sh", "/app/entry.sh"]
