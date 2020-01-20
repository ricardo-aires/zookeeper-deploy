# Apache Zookeeper

[ZooKeeper](https://zookeeper.apache.org) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services, used as a backend by distributed applications.

![ZooKeeper Logo](./img/zookeeper-logo.gif)

For this project we will be using the latest stable release [3.5.6](https://zookeeper.apache.org/doc/r3.5.6) and create the next deployment methods.

- [Ansible](ansible/roles/zookeeper/README.md)
- [Docker/Kubernetes](container/README.md)

## Considerations

The solutions provided were designed for Proof of Concepts. Hence, are not to be treated as production ready, especially because of the lack of Security settings.

### System Requirements

ZooKeeper runs in Java, release 1.7 or greater.

 It runs as an ensemble of ZooKeeper servers where three ZooKeeper servers is the minimum recommended size for an ensemble.

 > At Yahoo!, ZooKeeper is usually deployed on dedicated RHEL boxes, with dual-core processors, 2GB of RAM, and 80GB IDE hard drives. [¹](https://zookeeper.apache.org/doc/r3.5.6/zookeeperAdmin.html#sc_systemReq)

For development purposes it's possible to run in Single Server Mode.

### Architecture

For a production environment we should deploy in a cluster known as an ensemble.

As mentioned before, a minimum of three servers are required for a fault tolerant clustered setup, and it is strongly recommended that you have an odd number of servers, because Zookeeper requires a majority.

For example, with four machines ZooKeeper can only handle the failure of a single machine; if two machines fail, the remaining two machines do not constitute a majority. However, with five machines ZooKeeper can handle the failure of two machines.

To create a deployment that can tolerate the failure of F machines, you should count on deploying 2xF+1 machines. Thus, a deployment that consists of three machines can handle one failure, and a deployment of five machines can handle two failures.

> In ZooKeeper, quorum is the minimum number of servers that have to be running and available in order for ZooKeeper to work. In a 3-node ensemble a quorum of 2 is required.

Usually three servers is more than enough for a production install, but for maximum reliability during maintenance, you may wish to install five servers. With three servers, if you perform maintenance on one of them, you are vulnerable to a failure on one of the other two servers during that maintenance. If you have five of them running, you can take one down for maintenance, and know that you're still OK if one of the other four suddenly fails.

Your redundancy considerations should include all aspects of your environment. If you have three ZooKeeper servers, but their network cables are all plugged into the same network switch, then the failure of that switch will take down your entire ensemble.