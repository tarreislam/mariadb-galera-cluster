# Info
Easiest way to setup a MariaDB galera cluster 


1. Pull repo
2. `cp .env.example .env`
3. On first node set `WSREP_NEW_CLUSTER` to `true`
4. On all nodes set same `WSREP_CLUSTER_NAME`
5. On all nodes besides the first set `WSREP_SST_DONOR` to the node name of the previous node
6. On all nodes set the `WSREP_NODE_NAME` to a unique name
7. `docker-compose up -d mariadb`
8. Remove `WSREP_NEW_CLUSTER` on first node


### Example for 3 hosts

#### First node
```dotenv
WSREP_NEW_CLUSTER=true

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-01
WSREP_NODE_ADDRESS=10.0.1.15
WSREP_SST_DONOR=
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```

#### Second node

```dotenv
WSREP_NEW_CLUSTER=false

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-02
WSREP_NODE_ADDRESS=10.0.1.16
WSREP_SST_DONOR=node-01
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```

#### Third node

```dotenv
WSREP_NEW_CLUSTER=false

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-03
WSREP_NODE_ADDRESS=10.0.1.17
WSREP_SST_DONOR=node-02
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```

### Crashed clusters

If your cluster fails to start its probably because no node is safe to boot. Set `SAFE_TO_BOOTSTRAP=true` and `WSREP_NEW_CLUSTER=true` on the node you want to start


### Mega epic crashed clusters

If you somehow still have a crashed cluster add `START_WITHOUT_MYSQL=true` to successfully inspect/recover from your pod