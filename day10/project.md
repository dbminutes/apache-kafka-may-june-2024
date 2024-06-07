### 1. **Setup Apache Kafka Cluster**
- **Install Kafka**: Set up an Apache Kafka cluster. This can be done on-premises or using cloud services like AWS MSK, Confluent Cloud, or similar.
- **Configure Kafka**: Ensure you have the necessary Kafka topics for different data streams:
  - `user-registrations`
  - `access-logs`
  - `payment-transactions`
  - `user-updates`

### 2. **Data Ingestion**
- **User Registrations**:
  - Create a producer to send user registration data to the `user-registrations` topic.
  - Data schema could include `user_id`, `name`, `email`, `consented_to_newsletter`, `registration_date`.

- **Access Logs**:
  - Create a producer to send access logs to the `access-logs` topic.
  - Logs can include `timestamp`, `user_id`, `page_visited`, `session_id`.

- **Payment Transactions**:
  - Create a producer to send payment transaction data to the `payment-transactions` topic.
  - Data schema could include `user_id`, `transaction_id`, `amount`, `status`, `timestamp`.

- **User Updates**:
  - Create a producer to send user update actions (name, password changes) to the `user-updates` topic.
  - Data schema could include `user_id`, `update_type`, `timestamp`.

### 3. **Data Processing with Kafka Streams**
- **Count Registered Users**:
  - Create a Kafka Streams application to read from the `user-registrations` topic and maintain a count of unique `user_id`.
  - Store this count in a state store and expose it via a REST API for the dashboard.

- **Email Addresses for Marketing**:
  - Create a Kafka Streams application to filter users who have consented to the newsletter from the `user-registrations` topic.
  - Forward these records to a new topic `consented-users`.
  - Export data from `consented-users` to the marketing team's database periodically.

- **Popular Pages**:
  - Create a Kafka Streams application to process `access-logs` and count page visits.
  - Store the counts in a state store and expose popular pages via a REST API.

- **Payment Transactions Status**:
  - Create a Kafka Streams application to read from `payment-transactions` and count successful and failed transactions.
  - Forward failed transactions to a new topic `failed-transactions`.
  - Set up an email alert system to notify stakeholders of failed transactions by consuming from `failed-transactions`.

- **User Updates Frequency**:
  - Create a Kafka Streams application to process `user-updates` and count changes.
  - Store these counts in a state store and expose the frequency of changes via a REST API.

### 4. **Dashboard and Notifications**
- **Dashboard**:
  - Develop a web dashboard to display:
    - Total registered users (from user-registrations count).
    - Popular pages (from access logs processing).
    - Payment transaction statuses (from payment-transactions processing).
    - Frequency of user updates (from user-updates processing).

- **Notifications**:
  - Integrate an email service to send notifications for failed transactions.
  - Set up a periodic job to export consented user emails to the marketing database.

### 5. **Monitoring and Maintenance**
- **Monitoring Kafka**:
  - Set up monitoring for Kafka brokers and topics using tools like Prometheus and Grafana.
  - Ensure Kafka Streams applications are resilient and can recover from failures.

- **Scalability**:
  - Plan for scaling the Kafka cluster as data volume grows.
  - Ensure stream processing applications can handle increased load.

### 6. **Security and Compliance**
- **Data Security**:
  - Ensure sensitive data like user details and payment information is encrypted both in transit and at rest.
  - Implement access controls to secure Kafka topics and consumer groups.

- **Compliance**:
  - Ensure the project complies with relevant data protection regulations (e.g., GDPR, CCPA).
------------------------------


### Setting Up Kafka Cluster Using Docker Compose

Here's the second part of your tutorial, which includes steps to set up Docker Compose, start the Kafka cluster, and add DNS entries for the Kafka nodes.

#### 1. **Install Docker and Docker Compose**

Ensure Docker and Docker Compose are installed on your system. You can follow the official installation guides:

- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

#### 2. **Create Docker Compose File**

Create a file named `docker-compose.yml` and paste the provided Kafka cluster configuration into it.

```yaml
version: '3.8'
services:
  kafka1:
    image: 'confluentinc/cp-kafka:latest'
    container_name: kafka1
    environment:
      - CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
      - KAFKA_NODE_ID=1
      - KAFKA_PROCESS_ROLES=broker,controller
      - KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka1:9093,2@kafka2:9093,3@kafka3:9093,4@kafka4:9093,5@kafka5:9093
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://kafka1:9092,CONTROLLER://kafka1:9093
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka1:9092
      - KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_LOG_DIRS=/var/lib/kafka/data
    user: root
    command: ["sh", "-c", "chown -R appuser:appuser /var/lib/kafka/data && /etc/confluent/docker/run"]
    ports:
      - '9092:9092'
      - '9093:9093'
    volumes:
      - './data1:/var/lib/kafka/data'

  kafka2:
    image: 'confluentinc/cp-kafka:latest'
    container_name: kafka2
    environment:
      - CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
      - KAFKA_NODE_ID=2
      - KAFKA_PROCESS_ROLES=broker,controller
      - KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka1:9093,2@kafka2:9093,3@kafka3:9093,4@kafka4:9093,5@kafka5:9093
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://kafka2:9092,CONTROLLER://kafka2:9093
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka2:9092
      - KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_LOG_DIRS=/var/lib/kafka/data
    user: root
    command: ["sh", "-c", "chown -R appuser:appuser /var/lib/kafka/data && /etc/confluent/docker/run"]
    ports:
      - '9094:9092'
      - '9095:9093'
    volumes:
      - './data2:/var/lib/kafka/data'

  kafka3:
    image: 'confluentinc/cp-kafka:latest'
    container_name: kafka3
    environment:
      - CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
      - KAFKA_NODE_ID=3
      - KAFKA_PROCESS_ROLES=broker,controller
      - KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka1:9093,2@kafka2:9093,3@kafka3:9093,4@kafka4:9093,5@kafka5:9093
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://kafka3:9092,CONTROLLER://kafka3:9093
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka3:9092
      - KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_LOG_DIRS=/var/lib/kafka/data
    user: root
    command: ["sh", "-c", "chown -R appuser:appuser /var/lib/kafka/data && /etc/confluent/docker/run"]
    ports:
      - '9096:9092'
      - '9097:9093'
    volumes:
      - './data3:/var/lib/kafka/data'

  kafka4:
    image: 'confluentinc/cp-kafka:latest'
    container_name: kafka4
    environment:
      - CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
      - KAFKA_NODE_ID=4
      - KAFKA_PROCESS_ROLES=broker,controller
      - KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka1:9093,2@kafka2:9093,3@kafka3:9093,4@kafka4:9093,5@kafka5:9093
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://kafka4:9092,CONTROLLER://kafka4:9093
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka4:9092
      - KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_LOG_DIRS=/var/lib/kafka/data
    user: root
    command: ["sh", "-c", "chown -R appuser:appuser /var/lib/kafka/data && /etc/confluent/docker/run"]
    ports:
      - '9098:9092'
      - '9099:9093'
    volumes:
      - './data4:/var/lib/kafka/data'

  kafka5:
    image: 'confluentinc/cp-kafka:latest'
    container_name: kafka5
    environment:
      - CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
      - KAFKA_NODE_ID=5
      - KAFKA_PROCESS_ROLES=broker,controller
      - KAFKA_CONTROLLER_QUORUM_VOTERS=1@kafka1:9093,2@kafka2:9093,3@kafka3:9093,4@kafka4:9093,5@kafka5:9093
      - KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      - KAFKA_LISTENERS=PLAINTEXT://kafka5:9092,CONTROLLER://kafka5:9093
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka5:9092
      - KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_LOG_DIRS=/var/lib/kafka/data
    user: root
    command: ["sh", "-c", "chown -R appuser:appuser /var/lib/kafka/data && /etc/confluent/docker/run"]
    ports:
      - '9102:9092'
      - '9103:9093'
    volumes:
      - './data5:/var/lib/kafka/data'
```

#### 3. **Start the Kafka Cluster**

Navigate to the directory where your `docker-compose.yml` file is located and run the following command to start the Kafka cluster:

```bash
docker-compose up -d
```

This will start all the Kafka broker containers in the background.

#### 4. **Add DNS Entries in /etc/hosts**

To ensure that the Kafka brokers can resolve each other’s hostnames, add the following entries to your `/etc/hosts` file. You need root privileges to edit this file:

```plaintext
127.0.0.1 kafka1
127.0.0.1 kafka2
127.0.0.1 kafka3
127.0.0.1 kafka4
127.0.0.1 kafka5
```

You can edit the `/etc/hosts` file using a text editor like `nano` or `vim`:

```bash
sudo nano /etc/hosts
```

Add the entries at the end of the file, save, and exit the editor.

#### 5. **Verify the Kafka Cluster**

To verify that the Kafka cluster is running correctly, you can check the logs of one of the Kafka containers:

```bash
docker-compose logs kafka1
```

You can also use `kafka-topics.sh` to list topics and ensure that the brokers are correctly communicating:

```bash
docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:9092 --list
```

 --------------------------------------



### Setting Up Kafka Cluster on OpenShift Using `oc` CLI

Below are the steps to set up a Kafka cluster on OpenShift using the `oc` CLI and a deployment configuration.

#### 1. **Log in to OpenShift Cluster**

First, log in to your OpenShift cluster using the `oc` CLI:

```bash
oc login -u developer https://api.crc.testing:6443
```

#### 2. **Create a Project**

Create a new project for the Kafka cluster:

```bash
oc new-project kafka-cluster
```

#### 3. **Create Persistent Volume Claims (PVCs)**

Kafka requires persistent storage for its data. Create PVCs for each Kafka broker. Save the following YAML as `kafka-pvc.yml`:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka1-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka2-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka3-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka4-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kafka5-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

Apply the PVC configuration:

```bash
oc apply -f kafka-pvc.yml
```

#### 4. **Create Kafka Deployment Configuration**

Save the following YAML as `kafka-deployment.yml`. This will create a StatefulSet for the Kafka cluster:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
spec:
  selector:
    matchLabels:
      app: kafka
  serviceName: "kafka"
  replicas: 5
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
          name: client
        - containerPort: 9093
          name: controller
        env:
        - name: CLUSTER_ID
          value: fK-w8VSyRvaKJZgG4NME5A
        - name: KAFKA_NODE_ID
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: KAFKA_PROCESS_ROLES
          value: broker,controller
        - name: KAFKA_CONTROLLER_QUORUM_VOTERS
          value: 1@kafka-0.kafka:9093,2@kafka-1.kafka:9093,3@kafka-2.kafka:9093,4@kafka-3.kafka:9093,5@kafka-4.kafka:9093
        - name: KAFKA_LISTENER_SECURITY_PROTOCOL_MAP
          value: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
        - name: KAFKA_LISTENERS
          value: PLAINTEXT://:9092,CONTROLLER://:9093
        - name: KAFKA_ADVERTISED_LISTENERS
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: KAFKA_CONTROLLER_LISTENER_NAMES
          value: CONTROLLER
        - name: KAFKA_LOG_DIRS
          value: /var/lib/kafka/data
        volumeMounts:
        - name: kafka-storage
          mountPath: /var/lib/kafka/data
  volumeClaimTemplates:
  - metadata:
      name: kafka-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

Apply the deployment configuration:

```bash
oc apply -f kafka-deployment.yml
```

#### 5. **Expose Kafka Services**

Create services to expose Kafka brokers within the cluster. Save the following YAML as `kafka-service.yml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kafka
spec:
  ports:
  - port: 9092
    name: client
  - port: 9093
    name: controller
  clusterIP: None
  selector:
    app: kafka
```

Apply the service configuration:

```bash
oc apply -f kafka-service.yml
```

#### 6. **Verify the Kafka Cluster**

To verify that the Kafka cluster is running correctly, check the status of the StatefulSet:

```bash
oc get statefulsets
```

Check the logs of one of the Kafka pods:

```bash
oc logs kafka-0
```

### Adding DNS Entries in `/etc/hosts`

You need to ensure the pods can communicate using their service names. Add the following entries to your `/etc/hosts` file on your local machine for testing purposes:

```plaintext
127.0.0.1 kafka-0.kafka.kafka-cluster.svc.cluster.local
127.0.0.1 kafka-1.kafka.kafka-cluster.svc.cluster.local
127.0.0.1 kafka-2.kafka.kafka-cluster.svc.cluster.local
127.0.0.1 kafka-3.kafka.kafka-cluster.svc.cluster.local
127.0.0.1 kafka-4.kafka.kafka-cluster.svc.cluster.local
```

You can edit the `/etc/hosts` file using a text editor like `nano` or `vim`:

```bash
sudo nano /etc/hosts
```

Add the entries at the end of the file, save, and exit the editor.


=================================


### Node.js Script to Create Kafka Topics

Create a file named `create_kafka_topics.js`:

```javascript
const kafka = require('kafka-node');
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });

const topicsToCreate = [
  {
    topic: 'user-registrations',
    partitions: 1,
    replicationFactor: 1
  },
  {
    topic: 'access-logs',
    partitions: 1,
    replicationFactor: 1
  },
  {
    topic: 'payment-transactions',
    partitions: 1,
    replicationFactor: 1
  },
  {
    topic: 'user-updates',
    partitions: 1,
    replicationFactor: 1
  },
  {
    topic: 'marketing_data',
    partitions: 1,
    replicationFactor: 1
  }
];

client.createTopics(topicsToCreate, (error, result) => {
  if (error) {
    console.error('Error creating topics:', error);
  } else {
    console.log('Topics created successfully:', result);
  }
  client.close();
});
```

### Running the Script

1. Save the script to a file named `create_kafka_topics.js`.
2. Run the script using Node.js:

```bash
node create_kafka_topics.js
```

This Node.js script will create the following Kafka topics:
- `user-registrations`
- `access-logs`
- `payment-transactions`
- `user-updates`
- `marketing_data`

Each topic will be created with a replication factor of 1 and 1 partition. Adjust the replication factor and the number of partitions as needed.
-------------------------


### 1. **Generate Sample Data for User Registrations**

Create a file named `generate_user_registrations.js`:

```javascript
const kafka = require('kafka-node');
const Producer = kafka.Producer;
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });
const producer = new Producer(client);

const topic = 'user-registrations';

const generateUserRegistration = (userId) => {
  return JSON.stringify({
    user_id: userId,
    timestamp: Date.now(),
    name: `User${userId}`,
    email: `user${userId}@example.com`,
    consented_to_newsletter: true
  });
};

producer.on('ready', () => {
  for (let i = 1; i <= 100; i++) {
    const message = generateUserRegistration(i);
    producer.send([{ topic, messages: [message] }], (err, data) => {
      if (err) console.error(err);
      else console.log(`Sent: ${message}`);
    });
  }
});

producer.on('error', (err) => {
  console.error(err);
});
```

### 2. **Generate Sample Data for Access Logs**

Create a file named `generate_access_logs.js`:

```javascript
const kafka = require('kafka-node');
const Producer = kafka.Producer;
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });
const producer = new Producer(client);

const topic = 'access-logs';

const generateAccessLog = (userId) => {
  return JSON.stringify({
    timestamp: Date.now(),
    user_id: userId,
    page_visited: `/page${Math.floor(Math.random() * 10)}`,
    session_id: `session${userId}`
  });
};

producer.on('ready', () => {
  for (let i = 1; i <= 100; i++) {
    for (let j = 1; j <= 10; j++) {
      const message = generateAccessLog(i);
      producer.send([{ topic, messages: [message] }], (err, data) => {
        if (err) console.error(err);
        else console.log(`Sent: ${message}`);
      });
    }
  }
});

producer.on('error', (err) => {
  console.error(err);
});
```

### 3. **Generate Sample Data for Payment Transactions**

Create a file named `generate_payment_transactions.js`:

```javascript
const kafka = require('kafka-node');
const Producer = kafka.Producer;
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });
const producer = new Producer(client);

const topic = 'payment-transactions';

const generatePaymentTransaction = (userId, transactionId) => {
  const status = Math.random() < 0.5 ? 'SUCCESS' : 'FAILURE';
  return JSON.stringify({
    user_id: userId,
    transaction_id: transactionId,
    amount: 100.0,
    status: status,
    timestamp: Date.now()
  });
};

producer.on('ready', () => {
  for (let i = 1; i <= 100; i++) {
    for (let j = 1; j <= 5; j++) {
      const message = generatePaymentTransaction(i, j);
      producer.send([{ topic, messages: [message] }], (err, data) => {
        if (err) console.error(err);
        else console.log(`Sent: ${message}`);
      });
    }
  }
});

producer.on('error', (err) => {
  console.error(err);
});
```

### 4. **Generate Sample Data for User Updates**

Create a file named `generate_user_updates.js`:

```javascript
const kafka = require('kafka-node');
const Producer = kafka.Producer;
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });
const producer = new Producer(client);

const topic = 'user-updates';

const generateUserUpdate = (userId, updateType) => {
  return JSON.stringify({
    user_id: userId,
    update_type: updateType,
    timestamp: Date.now()
  });
};

producer.on('ready', () => {
  for (let i = 1; i <= 100; i++) {
    let message = generateUserUpdate(i, 'NAME_CHANGE');
    producer.send([{ topic, messages: [message] }], (err, data) => {
      if (err) console.error(err);
      else console.log(`Sent: ${message}`);
    });
    message = generateUserUpdate(i, 'PASSWORD_CHANGE');
    producer.send([{ topic, messages: [message] }], (err, data) => {
      if (err) console.error(err);
      else console.log(`Sent: ${message}`);
    });
  }
});

producer.on('error', (err) => {
  console.error(err);
});
```

### Running the Scripts

1. Save each script to a separate `.js` file, e.g., `generate_user_registrations.js`, `generate_access_logs.js`, etc.
2. Run each script using Node.js:

```bash
node generate_user_registrations.js
node generate_access_logs.js
node generate_payment_transactions.js
node generate_user_updates.js
```


=======================================

###  `generate_payment_transactions.js` Script with Idempotence Enabled

```javascript
const kafka = require('kafka-node');
const Producer = kafka.Producer;
const client = new kafka.KafkaClient({ kafkaHost: 'kafka1:9092' });

const producerOptions = {
  requireAcks: 1,
  idempotent: true // Enable idempotent producer
};

const producer = new Producer(client, producerOptions);

const topic = 'payment-transactions';

const generatePaymentTransaction = (userId, transactionId) => {
  const status = Math.random() < 0.5 ? 'SUCCESS' : 'FAILURE';
  return JSON.stringify({
    user_id: userId,
    transaction_id: transactionId,
    amount: 100.0,
    status: status,
    timestamp: Date.now()
  });
};

producer.on('ready', () => {
  const sendMessages = async () => {
    for (let i = 1; i <= 100; i++) {
      for (let j = 1; j <= 5; j++) {
        const message = generatePaymentTransaction(i, j);
        producer.send([{ topic, messages: [message] }], (err, data) => {
          if (err) console.error(err);
          else console.log(`Sent: ${message}`);
        });
      }
    }
  };

  sendMessages().catch(console.error);
});

producer.on('error', (err) => {
  console.error(err);
});

```

=======================================

### Data for Marketing Team

### Prerequisites

Make sure you have the `kafka-node` and `kafka-streams` libraries installed:

```bash
npm install kafka-node kafka-streams
```

### Stream Processing Script

Create a file named `process_user_registrations.js`:

```javascript
const { KafkaStreams } = require("kafka-streams");
const { KafkaClient } = require("kafka-node");

const kafkaConfig = {
  noptions: {
    "metadata.broker.list": "kafka1:9092",
    "group.id": "kafka-streams-group",
    "client.id": "kafka-streams-client",
    "event_cb": true,
    "compression.codec": "none",
    "api.version.request": true,
    "socket.keepalive.enable": true,
    "socket.blocking.max.ms": 100,
    "enable.auto.commit": false,
    "auto.commit.interval.ms": 100,
    "heartbeat.interval.ms": 250,
    "retry.backoff.ms": 250,
    "fetch.min.bytes": 100,
    "fetch.message.max.bytes": 2 * 1024 * 1024,
    "queued.min.messages": 100,
    "fetch.error.backoff.ms": 100,
    "queued.max.messages.kbytes": 50,
    "fetch.wait.max.ms": 1000,
    "batch.num.messages": 10000
  },
  tconf: {
    "auto.offset.reset": "earliest",
    "request.required.acks": 1
  }
};

const kafkaStreams = new KafkaStreams(kafkaConfig);
const stream = kafkaStreams.getKStream();

stream.from("user-registrations");

stream
  .filter(record => {
    const user = JSON.parse(record.value);
    return user.consented_to_newsletter;
  })
  .map(record => {
    const user = JSON.parse(record.value);
    return {
      topic: "marketing_data",
      value: JSON.stringify({
        user_id: user.user_id,
        name: user.name,
        email: user.email,
        timestamp: user.timestamp
      })
    };
  })
  .to("marketing_data", 1, "buffer");

kafkaStreams.start().then(() => {
  console.log("Stream started");
}).catch(error => {
  console.error("Stream failed to start:", error);
});

process.on("SIGINT", () => {
  kafkaStreams.closeAll().then(() => {
    console.log("Stream closed");
    process.exit();
  });
});
```

### Instructions for Automatic Setup

1. **Save the script** to a file named `process_user_registrations.js`.

2. **Ensure Kafka is running** and you have the `user-registrations` and `marketing_data` topics created. You can create the topics using the previous Node.js script provided.

3. **Run the stream processing script**:

```bash
node process_user_registrations.js
```

### Running the Stream Processor as a Background Service

To ensure that the stream processor runs automatically and continuously, you can set it up as a service or run it in the background. Here are two methods:

#### Method 1: Using `nohup`

You can use `nohup` to run the process in the background:

```bash
nohup node process_user_registrations.js &
```

This will keep the script running in the background even if you log out.

===========================

### Alerts on Payment Failure

### Prerequisites

Make sure you have the following packages installed:

```bash
npm install kafka-node kafka-streams nodemailer
```

### Stream Processing and Email Sending Script

Create a file named `process_payment_transactions.js`:

```javascript
const { KafkaStreams } = require("kafka-streams");
const nodemailer = require("nodemailer");

const kafkaConfig = {
  noptions: {
    "metadata.broker.list": "kafka1:9092",
    "group.id": "kafka-streams-group",
    "client.id": "kafka-streams-client",
    "event_cb": true,
    "compression.codec": "none",
    "api.version.request": true,
    "socket.keepalive.enable": true,
    "socket.blocking.max.ms": 100,
    "enable.auto.commit": false,
    "auto.commit.interval.ms": 100,
    "heartbeat.interval.ms": 250,
    "retry.backoff.ms": 250,
    "fetch.min.bytes": 100,
    "fetch.message.max.bytes": 2 * 1024 * 1024,
    "queued.min.messages": 100,
    "fetch.error.backoff.ms": 100,
    "queued.max.messages.kbytes": 50,
    "fetch.wait.max.ms": 1000,
    "batch.num.messages": 10000
  },
  tconf: {
    "auto.offset.reset": "earliest",
    "request.required.acks": 1
  }
};

const kafkaStreams = new KafkaStreams(kafkaConfig);
const stream = kafkaStreams.getKStream();

stream.from("payment-transactions");

// Email configuration
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",
    pass: "your-email-password"
  }
});

const sendFailureEmail = (transaction) => {
  const mailOptions = {
    from: "your-email@gmail.com",
    to: "stakeholder@example.com",
    subject: `Payment Failure Alert for User ${transaction.user_id}`,
    text: `A payment transaction for user ${transaction.user_id} with transaction ID ${transaction.transaction_id} has failed.`
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error(`Failed to send email: ${error}`);
    } else {
      console.log(`Email sent: ${info.response}`);
    }
  });
};

stream
  .filter(record => {
    const transaction = JSON.parse(record.value);
    return transaction.status === "FAILURE";
  })
  .map(record => {
    const transaction = JSON.parse(record.value);
    sendFailureEmail(transaction);
    return record;
  });

kafkaStreams.start().then(() => {
  console.log("Stream started");
}).catch(error => {
  console.error("Stream failed to start:", error);
});

process.on("SIGINT", () => {
  kafkaStreams.closeAll().then(() => {
    console.log("Stream closed");
    process.exit();
  });
});
```

### Instructions for Automatic Setup

1. **Save the script** to a file named `process_payment_transactions.js`.

2. **Ensure Kafka is running** and you have the `payment-transactions` topic created.

3. **Run the stream processing script**:

```bash
node process_payment_transactions.js
```

### Running the Stream Processor as a Background Service

To ensure that the stream processor runs automatically and continuously, you can set it up as a service or run it in the background. Here are two methods:

#### Method 1: Using `nohup`

You can use `nohup` to run the process in the background:

```bash
nohup node process_payment_transactions.js &
```

This will keep the script running in the background even if you log out.

============================================================


Sure! Below is a Node.js script that randomly selects a user from the `user-registrations` topic, changes their email address, and produces a message to the `user-email-changes` topic.

### Prerequisites

Make sure you have the `kafka-node` package installed:

```bash
npm install kafka-node
```

### Script to Change User Email and Produce a Message to another topic

Create a file named `change_user_email.js`:

```javascript
const kafka = require('kafka-node');
const { KafkaClient, Consumer, Producer } = kafka;

const client = new KafkaClient({ kafkaHost: 'kafka1:9092' });
const producer = new Producer(client);

const userRegistrationsTopic = 'user-registrations';
const userEmailChangesTopic = 'user-email-changes';

// Function to generate a new random email
const generateNewEmail = (userId) => `newuser${userId}@example.com`;

// Consumer to read from user-registrations
const consumer = new Consumer(
  client,
  [{ topic: userRegistrationsTopic, partition: 0 }],
  { autoCommit: false }
);

consumer.on('message', async (message) => {
  const user = JSON.parse(message.value);
  const randomChance = Math.random();
  
  // Randomly select a user
  if (randomChance < 0.1) { // Adjust the probability as needed
    const newEmail = generateNewEmail(user.user_id);
    const updatedUser = { ...user, email: newEmail };

    // Produce the message to user-email-changes topic
    producer.send([{ topic: userEmailChangesTopic, messages: JSON.stringify(updatedUser) }], (err, data) => {
      if (err) console.error('Error sending message:', err);
      else console.log('Email changed and message sent:', updatedUser);
    });
  }
});

consumer.on('error', (err) => {
  console.error('Error in consumer:', err);
});

producer.on('ready', () => {
  console.log('Producer is ready');
});

producer.on('error', (err) => {
  console.error('Error in producer:', err);
});
```

### Instructions

1. **Save the script** to a file named `change_user_email.js`.

2. **Ensure Kafka is running** and you have the `user-registrations` and `user-email-changes` topics created.

3. **Run the script** using Node.js:

```bash
node change_user_email.js
```

### Running the Script as a Background Service

To ensure that the script runs continuously and automatically, you can set it up as a service or run it in the background. Here are two methods:

#### Method 1: Using `nohup`

You can use `nohup` to run the process in the background:

```bash
nohup node change_user_email.js &
```

This will keep the script running in the background even if you log out.
