# Info
Easiest way to setup a MariaDB galera cluster 


1. Pull repo
2. `cp .env.example .env`
3. On first node set `WSREP_NEW_CLUSTER` to `true`
4. On all nodes set same `WSREP_CLUSTER_NAME`
5. On all nodes set `WSREP_SST_DONOR` to the node name of the previous node
6. On all nodes set `WSREP_NODE_NAME` to a unique name
7. `docker-compose up -d mariadb` on first node
8. set `WSREP_NEW_CLUSTER=false` on first node
9. create credentials for mariadb-backup `CREATE USER 'sst_user'@'%' IDENTIFIED BY 'sst_pass'; GRANT ALL PRIVILEGES ON *.* TO 'sst_user'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;`
10. Change `SST_AUTH_USER_PASS=sst_user:sst_pass` on all nodes 
11. Start the child nodes like step 7

### Example for 3 hosts

#### First node
```dotenv
WSREP_NEW_CLUSTER=true

WSREP_CLUSTER_NAME=MyCluster

WSREP_NODE_NAME=node-01
WSREP_NODE_ADDRESS=10.0.1.15

WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17

WSREP_SST_DONOR=node-02,node-03
WSREP_SST_METHOD=mariabackup
WSREP_SST_AUTH_USER_PASS=sst_user:sst_pass
```

#### Second node

```dotenv
WSREP_NEW_CLUSTER=false

WSREP_CLUSTER_NAME=MyCluster

WSREP_NODE_NAME=node-02
WSREP_NODE_ADDRESS=10.0.1.16

WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17

WSREP_SST_DONOR=node-01,node-03
WSREP_SST_METHOD=mariabackup
WSREP_SST_AUTH_USER_PASS=sst_user:sst_pass
```

#### Third node

```dotenv
WSREP_NEW_CLUSTER=false

WSREP_CLUSTER_NAME=MyCluster

WSREP_NODE_NAME=node-03
WSREP_NODE_ADDRESS=10.0.1.17

WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17

WSREP_SST_DONOR=node-01,node-02
WSREP_SST_METHOD=mariabackup
WSREP_SST_AUTH_USER_PASS=sst_user:sst_pass
```

### Rsync
If you want to waste your life debugging why rsync is not working you can set `WSREP_SST_METHOD=rsync` and `WSREP_SST_AUTH_USER_PASS=` to use Rsync.

### Crashed clusters

If your cluster fails to start its probably because no node is safe to boot. Set `SAFE_TO_BOOTSTRAP=true` and `WSREP_NEW_CLUSTER=true` on the node you want to start


### Mega epic crashed clusters

If you somehow still have a crashed cluster add `START_WITHOUT_MYSQL=true` to successfully inspect/recover from your pod.

### Remove mysql dir on boot
set `WIPE_MYSQL_DIR=yes_im_stupid`