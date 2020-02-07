# ZooKeeper in Kubernetes

The image created [here](../docker/README.md) may be used to spin a ZooKeeper Ensemble in [Kubernetes](https://kubernetes.io) using the [k8s-zookeeper-deploy.yml](./k8s-zookeeper-deploy.yml) file.

## Getting started

After building the image just run, from this directory:

```bash
kubectl apply -f ./k8s-zookeeper-deploy.yml
```

It will create:

- A [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) for our test
- An [headless service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) to expose all ports inside the cluster
- A [loadbalancer service](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) that exposes the [adminserver](http://zookeeper.apache.org/doc/r3.5.6/zookeeperAdmin.html#sc_adminserver_config) port
- A [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
- A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

## Considerations

### Variables

Unlike running in [docker](../docker/README.md#Start-in-Replicated-Mode), we shouldn't define `ZOO_MY_ID` and `ZOO_SERVERS`.

Instead `K8S_ZOO_REPLICAS` must be in place and set to the same number of the replicas in order to auto generate the id and the information of the ZooKeeper Ensemble.

All variables regarding [settings](../docker/README.md#Environment-Variables) may be used.

### Ports Expose

We are only setting a [loadbalancer service](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) that exposes the [adminserver](http://zookeeper.apache.org/doc/r3.5.6/zookeeperAdmin.html#sc_adminserver_config) port, not the client ports by design. But, we can in fact add the `2181` port to it.

### Scale

Due to the fact that entries in the `zoo.cfg` that make up the ZooKeeper Ensemble, `server.X`, always needs to be updated and we need to change the `K8S_ZOO_REPLICAS`, for us o scale ZooKeeper we must:

1. Change the [file](./k8s-zookeeper-deploy.yml) and update the `replicas` and the value of `K8S_ZOO_REPLICAS`

    ```yml
    ...
        spec:
      containers:
      - name: zookeeper
        imagePullPolicy: IfNotPresent
        image: "myzoo:1.0"
        resources:
          requests:
            memory: "2Gi"
            cpu: "0.5"
          limits:
            memory: "3Gi"
            cpu: "0.5"
        env:
        - name: K8S_ZOO_REPLICAS
          value: "3"
    ...
    ```

1. Apply the changes

    ```bash
    kubectl apply -f ./k8s-zookeeper-deploy.yml
    ```

1. Watch the changes:

    ```bash
    kubectl get pods -w
    NAME   READY   STATUS    RESTARTS   AGE
    zk-0   1/1     Running   0          12m
    zk-1   1/1     Running   0          12m
    zk-2   1/1     Running   0          12m
    zk-3   1/1     Running   0          6s
    zk-4   1/1     Running   0          3s
    zk-5   0/1     Pending   0          0s
    zk-5   0/1     ContainerCreating   0          1s
    zk-5   1/1     Running             0          3s
    zk-2   1/1     Terminating         0          12m
    zk-2   0/1     Terminating         0          12m
    zk-2   0/1     Pending             0          0s
    zk-2   0/1     ContainerCreating   0          0s
    zk-2   1/1     Running             0          1s
    zk-1   1/1     Terminating         0          12m
    zk-1   0/1     Terminating         0          12m
    zk-1   0/1     Pending             0          0s
    zk-1   0/1     ContainerCreating   0          0s
    zk-1   1/1     Running             0          2s
    zk-0   1/1     Terminating         0          12m
    zk-0   0/1     Terminating         0          12m
    zk-0   0/1     Pending             0          0s
    zk-0   0/1     ContainerCreating   0          0s
    zk-0   1/1     Running             0          2s
    ```
