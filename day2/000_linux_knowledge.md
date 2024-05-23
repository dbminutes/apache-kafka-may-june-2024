### Linux Knowledge for Running a Kafka Cluster on Red Hat Enterprise Linux with OpenShift

>[!IMPORTANT]
> Most of these commands are provided for learning purposes. Do not attempt to execute them in a production or testing environment unless you are fully confident in what you are doing.

#### Prerequisites
- Basic understanding of Linux command-line interface.
- Access to a RHEL system.
- OpenShift installed and running.

### 1. Basic Linux System Administration

#### 1.1. User and Group Management
- **Creating Users**: `sudo useradd username`
- **Creating Groups**: `sudo groupadd groupname`
- **Adding Users to Groups**: `sudo usermod -aG groupname username`
- **Switching Users**: `su - username`

#### 1.2. File System Navigation
- **List Files**: `ls -l`
- **Change Directory**: `cd /path/to/directory`
- **View File Contents**: `cat filename`, `less filename`
- **Copy, Move, and Delete Files**: `cp source destination`, `mv source destination`, `rm filename`

#### 1.3. Package Management
- **Updating Packages**: `sudo yum update`
- **Installing Packages**: `sudo yum install package-name`
- **Removing Packages**: `sudo yum remove package-name`

### 2. Networking

#### 2.1. Basic Networking Commands
- **Check IP Address**: `ip addr show`
- **Check Network Connections**: `netstat -tuln`
- **Ping a Host**: `ping hostname_or_ip`
- **DNS Lookup**: `nslookup hostname`

#### 2.2. Firewall Management
- **Start/Stop Firewall**: `sudo systemctl start firewalld`, `sudo systemctl stop firewalld`
- **Allow Ports**: `sudo firewall-cmd --add-port=9092/tcp --permanent`, `sudo firewall-cmd --reload`

### 3. Storage

#### 3.1. Disk Management
- **Check Disk Usage**: `df -h`
- **Check Disk Inodes**: `df -i`
- **Check Disk Free Space**: `du -sh /path/to/directory`

#### 3.2. Mounting and Unmounting Filesystems
- **Mount a Filesystem**: `sudo mount /dev/sdX /mnt`
- **Unmount a Filesystem**: `sudo umount /mnt`

### 4. System Performance Monitoring

#### 4.1. Resource Usage
- **CPU Usage**: `top`, `htop`
- **Memory Usage**: `free -h`
- **Disk I/O**: `iostat`, `iotop`

#### 4.2. System Logs
- **View Logs**: `journalctl -xe`
- **Specific Service Logs**: `journalctl -u service-name`

### 5. Running Kafka on RHEL

#### 5.1. Installation
- **Download Kafka**:
  ```sh
  wget https://downloads.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
  ```
- **Extract Kafka**:
  ```sh
  tar -xzf kafka_2.13-3.3.1.tgz
  cd kafka_2.13-3.3.1
  ```

#### 5.2. Configuration
- **Configure Zookeeper**:
  ```sh
  nano config/zookeeper.properties
  ```
- **Configure Kafka Broker**:
  ```sh
  nano config/server.properties
  ```
  Update `broker.id`, `log.dirs`, and `zookeeper.connect`.

#### 5.3. Starting Kafka and Zookeeper
- **Start Zookeeper**:
  ```sh
  bin/zookeeper-server-start.sh config/zookeeper.properties
  ```
- **Start Kafka Broker**:
  ```sh
  bin/kafka-server-start.sh config/server.properties
  ```

### 6. OpenShift Container Platform

#### 6.1. Basics of OpenShift
- **Login to OpenShift**:
  ```sh
  oc login https://openshift-cluster-url:8443
  ```
- **Create a New Project**:
  ```sh
  oc new-project kafka-project
  ```

#### 6.2. Deploying Kafka on OpenShift
- **Deploy Kafka using StatefulSet**:
  ```yaml
  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: kafka
    namespace: kafka-project
  spec:
    serviceName: "kafka"
    replicas: 3
    selector:
      matchLabels:
        app: kafka
    template:
      metadata:
        labels:
          app: kafka
      spec:
        containers:
        - name: kafka
          image: confluentinc/cp-kafka:latest
          ports:
          - containerPort: 9092
            name: kafka
  ```

- **Apply the Deployment**:
  ```sh
  oc apply -f kafka-statefulset.yaml
  ```

#### 6.3. Networking and Storage in OpenShift
- **Expose Kafka Service**:
  ```sh
  oc expose svc kafka
  ```
- **Create Persistent Volume (PV)**:
  ```yaml
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: kafka-pv
  spec:
    capacity:
      storage: 10Gi
    accessModes:
      - ReadWriteOnce
    hostPath:
      path: /mnt/data/kafka
  ```

- **Apply the PV**:
  ```sh
  oc apply -f kafka-pv.yaml
  ```

### 7. Security and Best Practices

#### 7.1. Securing Kafka
- **Configure SSL**: 
  Configure Kafka brokers and clients to use SSL for encryption.
  ```properties
  ssl.keystore.location=/var/private/ssl/kafka.server.keystore.jks
  ssl.keystore.password=password
  ssl.key.password=password
  ```

- **Configure SASL/PLAIN**:
  ```properties
  security.inter.broker.protocol=SASL_SSL
  sasl.mechanism.inter.broker.protocol=PLAIN
  sasl.enabled.mechanisms=PLAIN
  ```

#### 7.2. OpenShift Security
- **Create Security Context Constraints (SCC)**:
  ```yaml
  apiVersion: v1
  kind: SecurityContextConstraints
  metadata:
    name: kafka-scc
  allowPrivilegedContainer: false
  runAsUser:
    type: RunAsAny
  seLinuxContext:
    type: MustRunAs
  fsGroup:
    type: RunAsAny
  ```

- **Apply SCC**:
  ```sh
  oc apply -f kafka-scc.yaml
  ```
