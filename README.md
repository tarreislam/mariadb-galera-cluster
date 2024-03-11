# Info
Easiest way to setup a MariaDB galera cluster 


1. Pull repo
2. `cp .env.example .env`
3. On first node set `MASTER_NODE` to `true`
4. On all nodes set same `WSREP_CLUSTER_NAME`
5. On all nodes besides the first set `WSREP_SST_DONOR` to the node name of the previous node
6. On all nodes set the `WSREP_NODE_NAME` to a unique name
7. docker-compose up -d mariadb


### Example for 3 hosts

#### First node
```dotenv
MASTER_NODE=true

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-01
WSREP_SST_DONOR=
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```

#### Second node

```dotenv
MASTER_NODE=false

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-02
WSREP_SST_DONOR=node-01
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```

#### Third node

```dotenv
MASTER_NODE=false

WSREP_CLUSTER_NAME=MyCluster
WSREP_NODE_NAME=node-03
WSREP_SST_DONOR=node-02
WSREP_CLUSTER_ADDRESS=10.0.1.15,10.0.1.16,10.0.1.17
```