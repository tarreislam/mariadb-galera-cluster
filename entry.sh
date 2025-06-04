#!/bin/bash
# Setup params for default
sed -i "s|%innodb_buffer_pool_size%|$innodb_buffer_pool_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_buffer_pool_instances%|$innodb_buffer_pool_instances|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_log_file_size%|$innodb_log_file_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_log_buffer_size%|$innodb_log_buffer_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_flush_method%|$innodb_flush_method|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_flush_neighbors%|$innodb_flush_neighbors|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_io_capacity%|$innodb_io_capacity|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_io_capacity_max%|$innodb_io_capacity_max|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_read_io_threads%|$innodb_read_io_threads|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%innodb_write_io_threads%|$innodb_write_io_threads|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%query_cache_type%|$query_cache_type|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%query_cache_size%|$query_cache_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%tmp_table_size%|$tmp_table_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%max_heap_table_size%|$max_heap_table_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%table_open_cache%|$table_open_cache|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%table_open_cache_instances%|$table_open_cache_instances|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%thread_cache_size%|$thread_cache_size|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%max_connections%|$max_connections|g" /etc/mysql/mariadb.conf.d/1337-my.cnf
sed -i "s|%max_connect_errors%|$max_connect_errors|g" /etc/mysql/mariadb.conf.d/1337-my.cnf

# Setup params for galera
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

# force safe to bootstrap
if [ "$SAFE_TO_BOOTSTRAP" = "true" ]; then
    echo "SAFE_TO_BOOTSTRAP = true"
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
    /usr/sbin/mariadbd --wsrep-new-cluster
else
    echo "WSREP_NEW_CLUSTER = false"
    /usr/sbin/mariadbd
fi
