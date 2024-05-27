# Setting up Kafka Environment (Installation & Configuration)


### Step 1: Check Java

Kafka requires Java to run. Ensure Java is installed on your system.

```sh
java -version
```
If it is not available, install it. 

### Step 2: Download and Extract Kafka

1. **Download Kafka:**

   Visit the [Apache Kafka download page](https://kafka.apache.org/downloads) and get the latest binary version.

   ```sh
   wget https://downloads.apache.org/kafka/3.7.0/kafka_2.12-3.7.0.tgz
   ```

2. **Extract Kafka:**

   ```sh
   tar -xzf kafka_2.12-3.7.0.tgz
   mv kafka_2.12-3.7.0 /usr/local/kafka
   ```

### Step 3: Start Zookeeper

Kafka uses Zookeeper to manage distributed brokers. Start Zookeeper first.

1. **Create Zookeeper Configuration:**

   ```sh
   nano /usr/local/kafka/config/zookeeper.properties
   ```

   Ensure the following configurations are present:

   ```properties
   dataDir=/var/lib/zookeeper
   clientPort=2181
   maxClientCnxns=60
   ```

2. **Start Zookeeper:**

   ```sh
   /usr/local/kafka/bin/zookeeper-server-start.sh  /usr/local/kafka/config/zookeeper.properties
   ```

### Step 4: Start Kafka Broker

1. **Create Kafka Configuration:**

   ```sh
   nano /usr/local/kafka/config/server.properties
   ```

   Ensure the following configurations are present:

   ```properties
   broker.id=0
   listeners=PLAINTEXT://:9092
   log.dirs=/var/lib/kafka
   zookeeper.connect=localhost:2181
   ```

2. **Start Kafka:**

   ```sh
   /usr/local/kafka/bin/kafka-server-start.sh  /usr/local/kafka/config/server.properties
   ```

### Step 5: Create Kafka Systemd Unit Files (Optional)

Creating systemd unit files allows Kafka to run as a service.

1. **Create Zookeeper Service File:**

   ```sh
   sudo nano /etc/systemd/system/zookeeper.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Apache Zookeeper server
   Documentation=http://zookeeper.apache.org
   Requires=network.target remote-fs.target
   After=network.target remote-fs.target

   [Service]
   Type=simple
   ExecStart=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
   ExecStop=/usr/local/kafka/bin/zookeeper-server-stop.sh
   Restart=on-abnormal

   [Install]
   WantedBy=multi-user.target
   ```

2. **Create Kafka Service File:**

   ```sh
   sudo nano /etc/systemd/system/kafka.service
   ```

   Add the following content:

   ```ini
   [Unit]
   Description=Apache Kafka server (broker)
   Documentation=http://kafka.apache.org/documentation.html
   Requires=zookeeper.service
   After=zookeeper.service

   [Service]
   Type=simple
   ExecStart=/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties
   ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh
   Restart=on-abnormal

   [Install]
   WantedBy=multi-user.target
   ```

3. **Reload systemd and Start Services:**

   ```sh
   sudo systemctl start zookeeper
   sudo systemctl start kafka
   ```

4. **Enable Services to Start on Boot:**

   ```sh
   sudo systemctl enable zookeeper
   sudo systemctl enable kafka
   ```

### Step 6: Verify Kafka Installation (Optional, if not using services)

1. **Check Zookeeper Status:**

   ```sh
   sudo systemctl status zookeeper
   ```

2. **Check Kafka Status:**

   ```sh
   sudo systemctl status kafka
   ```
