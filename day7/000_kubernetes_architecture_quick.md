### Traditional Virtualization Architecture

```mermaid
graph BT
    A[Physical Server]
    A --> B[Hypervisor]
    B --> VM1[Virtual Machine 1]
    B --> VM2[Virtual Machine 2]
    B --> VM3[Virtual Machine 3]
    VM1 --> OS1[Guest OS 1]
    VM2 --> OS2[Guest OS 2]
    VM3 --> OS3[Guest OS 3]
    OS1 --> App1[Application 1]
    OS2 --> App2[Application 2]
    OS3 --> App3[Application 3]
```

### Containers Architecture

```mermaid
graph BT
    A[Physical Server]
    A --> B[Host OS]
    B --> C[Container Runtime]
    C --> Container1[Container 1]
    C --> Container2[Container 2]
    C --> Container3[Container 3]
    Container1 --> App1[Application 1]
    Container2 --> App2[Application 2]
    Container3 --> App3[Application 3]
```

---------------




### Kafka Cluster with Multiple Brokers and a Single Zookeeper

```mermaid
graph TD
    subgraph Kafka Cluster
        direction TB
        Zookeeper[Zookeeper]

        subgraph Brokers
            direction LR
            Broker1[Broker 1]
            Broker2[Broker 2]
            Broker3[Broker 3]
        end
    end

    Producer1[Producer 1] --> Broker1
    Producer2[Producer 2] --> Broker2
    Producer3[Producer 3] --> Broker3

    Broker1 --> Zookeeper
    Broker2 --> Zookeeper
    Broker3 --> Zookeeper

    Broker1 --> Consumer1[Consumer 1]
    Broker2 --> Consumer2[Consumer 2]
    Broker3 --> Consumer3[Consumer 3]
```

----------------------


### Traditional Container Application on a Single Node

```mermaid
graph TD
    A[Single Node] --> B[Container Runtime]
    B --> C[App Container 1]
    B --> D[App Container 2]
    B --> E[App Container 3]
```

### Kubernetes Architecture

```mermaid
graph TD
    subgraph Kubernetes Cluster
        direction LR
        Master1[Master Node]
        Master1 --> APIServer[API Server]
        Master1 --> Scheduler[Scheduler]
        Master1 --> Controller[Controller Manager]
        Master1 --> ETCD[ETCD]

        subgraph Worker Nodes
            direction TB
            Worker1[Worker Node 1]
            Worker2[Worker Node 2]
            Worker3[Worker Node 3]

            Worker1 --> Kubelet1[Kubelet]
            Worker1 --> Proxy1[Kube-Proxy]
            Kubelet1 --> Pod1[Pod 1]
            Pod1 --> Container1A[Container 1A]
            Pod1 --> Container1B[Container 1B]

            Worker2 --> Kubelet2[Kubelet]
            Worker2 --> Proxy2[Kube-Proxy]
            Kubelet2 --> Pod2[Pod 2]
            Pod2 --> Container2A[Container 2A]
            Pod2 --> Container2B[Container 2B]

            Worker3 --> Kubelet3[Kubelet]
            Worker3 --> Proxy3[Kube-Proxy]
            Kubelet3 --> Pod3[Pod 3]
            Pod3 --> Container3A[Container 3A]
            Pod3 --> Container3B[Container 3B]
        end
    end

    APIServer --> WorkerNodes
    Scheduler --> WorkerNodes
    Controller --> WorkerNodes
```
