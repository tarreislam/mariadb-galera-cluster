#!/bin/bash
echo "~ MYSQL VERSION ~"
mysql --version
echo "~ LOADED CONF ~"
cat /etc/mysql/conf.d/galera.cnf
echo "~ ATTEMTING TO START MYSQLD ~"
if [ "$MASTER_NODE" = "true" ]; then
    echo "MASTER_NODE = true"
    #galera_new_cluster
    mysqld --wsrep-new-cluster
else
    echo "MASTER_NODE = false"
    mysqld
fi