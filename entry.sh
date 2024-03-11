#!/bin/bash
# Setup params
sed -i "s|%WSREP_CLUSTER_NAME%|$WSREP_CLUSTER_NAME|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_SST_DONOR%|$WSREP_SST_DONOR|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_CLUSTER_ADDRESS%|$WSREP_CLUSTER_ADDRESS|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_NODE_NAME%|$WSREP_NODE_NAME|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_NODE_ADDRESS%|$WSREP_NODE_ADDRESS|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_SST_METHOD%|$WSREP_SST_METHOD|g" /etc/mysql/conf.d/galera.cnf
sed -i "s|%WSREP_SST_AUTH_USER_PASS%|$WSREP_SST_AUTH_USER_PASS|g" /etc/mysql/conf.d/galera.cnf
# Show some debug info
echo "~ MYSQL VERSION ~"
mysql --version
echo "~ LOADED CONF ~"
cat /etc/mysql/conf.d/galera.cnf
echo "~ current /var/lib/mysql/grastate.dat ~"
cat /var/lib/mysql/grastate.dat

# Safe to bootstrap (in case of crash)
if [ "$SAFE_TO_BOOTSTRAP" = "true" ]; then
    echo "SAFE_TO_BOOTSTRAP = true"
    #galera_new_cluster
    sed -i 's/safe_to_bootstrap: 0/safe_to_bootstrap: 1/' /var/lib/mysql/grastate.dat
fi

# Incase Mysqld crashes 24\7 we can just sleep so we can do manual debugging
if [ "$START_WITHOUT_MYSQL" = "true" ]; then
    echo "START_WITHOUT_MYSQL = true"
    sleep infinity
fi
# Actual start
echo "~ ATTEMTING TO START MYSQLD ~"
if [ "$WSREP_NEW_CLUSTER" = "true" ]; then
    echo "WSREP_NEW_CLUSTER = true"
    #galera_new_cluster
    mysqld --wsrep-new-cluster
else
    echo "WSREP_NEW_CLUSTER = false"
    mysqld
fi