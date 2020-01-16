# ZooKeeper Dockerfile

[Dockerfile](https://docs.docker.com/engine/reference/builder/) to build a Docker image with [ZooKeeper](https://zookeeper.apache.org).

> This was done in a Proof of Concept project, were it wasn't possible to use the [ZooKeeper Docker Official Image](https://hub.docker.com/_/zookeeper).

## Getting Started

In order to build the image just clone the repo to your machine and run [docker build](https://docs.docker.com/engine/reference/commandline/build/) inside the [build](./build/) directory where the [Dockerfile](./build/Dockerfile) and [docker-entrypoint.sh](./build/docker-entrypoint.sh) are. Example:

```bash
docker build -t myzoo:1.0 .
```

### Prerequisities

In order to build the image and run this container you'll need docker installed.

This was tested using [Docker Desktop](https://www.docker.com/products/docker-desktop) for MacOS version 2.1.0.5.

### Base Image

The base image used in this case was the [openjdk:8 Docker Official Image](https://hub.docker.com/_/openjdk). When running inside a organization we should use a base image with:

- java
- bash
- wget

### Usage

#### Start in Standalone Mode

In order to run a [single node](https://zookeeper.apache.org/doc/r3.5.6/zookeeperStarted.html#sc_InstallingSingleMode) ZooKeeper Server we may just use the next [docker run](https://docs.docker.com/engine/reference/commandline/container_run/) :

```bash
docker container run --detach --restart always --name zk-0 myzoo:1.0
```

> Remember to change the image name if you choose another one when building.

The image expose the next ports:

- 2181/TCP - Client port
- 2888/TCP - Follwer port
- 3888/TCP - Election port
- 8080/TCP - Admin Server

In that case, in a single node, if we want to forward the client and admin server port we can:

```bash
docker container run --detach --restart always --publish 2181:2181 --publish 8081:8080 --name zk-0 myzoo:1.0
```

#### Start in Replicated Mode

In order to run in [replicated mode](https://zookeeper.apache.org/doc/r3.5.6/zookeeperStarted.html#sc_RunningReplicatedZooKeeper) some variables need to be passed:

- `ZOO_MY_ID` - the unique id to be used by the "server"
- `ZOO_SERVERS` - the list of hosts to be used in the ZooKeeper ensemble.

We can use this [docker-compose file](https://docs.docker.com/compose/compose-file/) found [here](./docker-compose.yml) to spin a 3-node ensemble.

It will:

- build the image and tag it as `myzoo:1.0`
- expose the client and admin server
- mount the data volume in order to persist accross recriation

#### Volumes

The only volume exposed is the one for the ZooKeeper Data directoy, at `/data`.

#### Run Replicated in Kubernetes

The image may be used to spin a ZooKeeper Ensemble in [Kubernetes](https://kubernetes.io) using the [k8s-zookeeper.yml](./k8s-zookeeper.yml) file:

```bash
kubectl apply -f ./k8s-zookeeper.yml
```

> Be aware that one variable must be in place, `K8S_ZOO_REPLICAS` and should be set to the same number of the replicas.

#### Environment Variables

Other variables to ease the settings:

- `ZOO_TICK_TIME`: the length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds.
- `ZOO_INIT_LIMIT`: amount of time, in ticks, to allow followers to connect and sync to a leader.
- `ZOO_SYNC_LIMIT`: amount of time, in ticks, to allow followers to sync with ZooKeeper.
- `ZOO_AUTOPURGE_PURGEINTERVAL`: the time interval in hours for which the purge task has to be triggered.
- `ZOO_AUTOPURGE_SNAPRETAINCOUNT`: number of most recent snapshots and the corresponding transaction logs in the dataDir and dataLogDir to keep.
- `ZOO_MAX_CLIENT_CNXNS`: number of concurrent connections (at the socket level) that a single client, identified by IP address, may make to a single member of the ZooKeeper ensemble.
- `ZK_SERVER_HEAP`: Heap Size to be set to the ZooKeeper Server.
