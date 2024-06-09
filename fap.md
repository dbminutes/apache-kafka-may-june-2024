#### Frequently Asked Programs

To increase the replication factor of a Kafka topic, you need to change the replication factor for the entire topic, not just individual messages. Kafka does not support changing the replication factor for individual messages directly. Here’s how you can increase the replication factor of a Kafka topic using the Kafka command-line tools:

### Steps to Increase the Replication Factor of a Kafka Topic

1. **Generate the Current Topic Configuration:**

   Use the `kafka-reassign-partitions.sh` tool to generate a reassignment JSON file. This file will include the current topic configuration.

   ```bash
   bin/kafka-reassign-partitions.sh --zookeeper localhost:2181 --generate --topics-to-move-json-file topics-to-move.json --broker-list "1,2,3"
   ```

   Create the `topics-to-move.json` file with the topic name and partition details. For example:

   ```json
   {
     "topics": [
       {
         "topic": "your_topic_name"
       }
     ],
     "version": 1
   }
   ```

   This command generates a JSON file with the current replica assignment.

2. **Edit the Reassignment JSON File:**

   Edit the generated JSON file to increase the replication factor. Here’s an example of how the JSON file might look after editing:

   ```json
   {
     "version": 1,
     "partitions": [
       {
         "topic": "your_topic_name",
         "partition": 0,
         "replicas": [1, 2, 3]
       },
       {
         "topic": "your_topic_name",
         "partition": 1,
         "replicas": [2, 3, 1]
       }
     ]
   }
   ```

   In this example, the replication factor is increased to 3 by adding more brokers to the `replicas` array for each partition.

3. **Execute the Reassignment:**

   Use the edited JSON file to execute the reassignment and increase the replication factor.

   ```bash
   bin/kafka-reassign-partitions.sh --zookeeper localhost:2181 --execute --reassignment-json-file reassignment.json
   ```

4. **Verify the Reassignment:**

   After executing the reassignment, verify that the replication factor has increased.

   ```bash
   bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic your_topic_name
   ```

   The output should show the new replication factor for the topic partitions.

### Example Workflow

Here’s an example workflow, assuming your topic name is `example-topic` and you want to increase the replication factor from 2 to 3.

1. Create the `topics-to-move.json` file:

   ```json
   {
     "topics": [
       {
         "topic": "example-topic"
       }
     ],
     "version": 1
   }
   ```

2. Generate the current assignment:

   ```bash
   bin/kafka-reassign-partitions.sh --zookeeper localhost:2181 --generate --topics-to-move-json-file topics-to-move.json --broker-list "1,2,3"
   ```

   This generates a file similar to this:

   ```json
   {
     "version": 1,
     "partitions": [
       {
         "topic": "example-topic",
         "partition": 0,
         "replicas": [1, 2]
       },
       {
         "topic": "example-topic",
         "partition": 1,
         "replicas": [2, 1]
       }
     ]
   }
   ```

3. Edit the generated file to increase the replication factor:

   ```json
   {
     "version": 1,
     "partitions": [
       {
         "topic": "example-topic",
         "partition": 0,
         "replicas": [1, 2, 3]
       },
       {
         "topic": "example-topic",
         "partition": 1,
         "replicas": [2, 1, 3]
       }
     ]
   }
   ```

4. Execute the reassignment:

   ```bash
   bin/kafka-reassign-partitions.sh --zookeeper localhost:2181 --execute --reassignment-json-file reassignment.json
   ```

5. Verify the reassignment:

   ```bash
   bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic example-topic
   ```

------------------------------

### Setting Up KRaft Mode with Kafka

Kafka’s KRaft (Kafka Raft) mode allows you to run Kafka without ZooKeeper. Follow these steps to set up a Kafka cluster using KRaft:

### Prerequisites
- Java 8+ installed.
- Downloaded Kafka binaries. Kafka 2.8.0 or later is required for KRaft mode.

### Step-by-Step Setup


#### 1. Configure Kafka for KRaft Mode

Create a `server.properties` file with the necessary KRaft configurations. Here is a basic example:

```properties
# server.properties

# Kafka broker ID
node.id=1

# Define log directories
log.dirs=/tmp/kraft-combined-logs

# Configure listeners
listeners=PLAINTEXT://localhost:9092,CONTROLLER://localhost:9093

# Enable KRaft mode
process.roles=broker,controller

# Specify the controller quorum voters (node.id@host:port)
controller.quorum.voters=1@localhost:9093

# Bootstrap servers
inter.broker.listener.name=PLAINTEXT

# Directory to store metadata
metadata.log.dir=/tmp/kraft-metadata

# Specify initial broker IDs
num.io.threads=8
num.network.threads=8
```

#### 2. Format the Storage Directory

Before starting the Kafka broker in KRaft mode, you need to format the storage directory to initialize the metadata.

```bash
bin/kafka-storage.sh format -t <uuid> -c config/server.properties
```

Replace `<uuid>` with a unique identifier for your Kafka cluster. You can generate a UUID using a tool like `uuidgen`.

```bash
uuidgen
```

#### 3. Start the Kafka Broker

Start the Kafka broker using the configured properties.

```bash
bin/kafka-server-start.sh config/server.properties
```

#### 4. Verify the Setup

After starting the broker, verify that it is running correctly. Check the logs in the configured `log.dirs` directory and the console output.

### Example Configuration Files

#### server.properties

```properties
node.id=1
log.dirs=/tmp/kraft-combined-logs
listeners=PLAINTEXT://localhost:9092,CONTROLLER://localhost:9093
process.roles=broker,controller
controller.quorum.voters=1@localhost:9093
inter.broker.listener.name=PLAINTEXT
metadata.log.dir=/tmp/kraft-metadata
num.io.threads=8
num.network.threads=8
```

#### Additional Brokers

For a multi-node setup, repeat the configuration for each broker with unique `node.id`, `listeners`, and `controller.quorum.voters` entries.

```properties
node.id=2
log.dirs=/tmp/kraft-combined-logs
listeners=PLAINTEXT://localhost:9094,CONTROLLER://localhost:9095
process.roles=broker,controller
controller.quorum.voters=1@localhost:9093,2@localhost:9095
inter.broker.listener.name=PLAINTEXT
metadata.log.dir=/tmp/kraft-metadata
num.io.threads=8
num.network.threads=8
```

### Important Considerations

- **Data Loss:** The storage format step will remove any existing data in the specified directories. Ensure these directories are empty or backed up if they contain important data.
- **Cluster Management:** Use the `kafka-storage.sh` tool to manage metadata and storage configurations.
- **Compatibility:** Ensure all Kafka clients are compatible with the Kafka version running in KRaft mode.

-----------------------------------------


To use a key in your Kafka message to act as a duplicate finder, you can follow these steps:

1. **Set the Key in Your Producer:**
   When you send messages to a Kafka topic, set a unique key for each message. Kafka ensures that messages with the same key are sent to the same partition, maintaining their order.

   Here’s an example using a Node.js Kafka client:

   ```javascript
   const { Kafka } = require('kafkajs');

   const kafka = new Kafka({
     clientId: 'my-producer',
     brokers: ['kafka-broker1:9092', 'kafka-broker2:9092']
   });

   const producer = kafka.producer();

   const sendMessage = async () => {
     await producer.connect();
     await producer.send({
       topic: 'your-topic',
       messages: [
         { key: 'unique-key-1', value: 'message content 1' },
         { key: 'unique-key-2', value: 'message content 2' },
         // more messages
       ],
     });

     await producer.disconnect();
   };

   sendMessage().catch(console.error);
   ```

2. **Consume Messages and Check for Duplicates:**
   When consuming messages, you can maintain a set of keys to track duplicates. Here’s an example:

   ```javascript
   const consumer = kafka.consumer({ groupId: 'my-group' });

   const consumeMessages = async () => {
     await consumer.connect();
     await consumer.subscribe({ topic: 'your-topic', fromBeginning: true });

     const seenKeys = new Set();

     await consumer.run({
       eachMessage: async ({ topic, partition, message }) => {
         const key = message.key.toString();
         const value = message.value.toString();

         if (seenKeys.has(key)) {
           console.log(`Duplicate message found with key: ${key}`);
         } else {
           seenKeys.add(key);
           console.log(`New message received: ${value}`);
         }
       },
     });
   };

   consumeMessages().catch(console.error);
   ```

3. **Considerations for Large Scale Applications:**
   - **State Management:** If you are dealing with a large number of messages, you might need to use a more scalable state management system (like Redis or a database) to track the keys instead of keeping them in memory.
   - **Windowing and TTL:** To avoid memory bloat, you can implement a time-to-live (TTL) for keys or use a windowing mechanism to limit the time frame for duplicate detection.

### Example Using Redis for State Management

Here's an example where you use Redis to track message keys:

1. **Install Redis and the Redis Client:**

   ```bash
   npm install redis
   ```

2. **Modify the Consumer to Use Redis:**

   ```javascript
   const redis = require('redis');
   const redisClient = redis.createClient();

   redisClient.on('error', (err) => {
     console.error('Redis error:', err);
   });

   const consumeMessagesWithRedis = async () => {
     await consumer.connect();
     await consumer.subscribe({ topic: 'your-topic', fromBeginning: true });

     await consumer.run({
       eachMessage: async ({ topic, partition, message }) => {
         const key = message.key.toString();
         const value = message.value.toString();

         redisClient.get(key, (err, reply) => {
           if (err) {
             console.error('Redis GET error:', err);
           } else if (reply) {
             console.log(`Duplicate message found with key: ${key}`);
           } else {
             redisClient.set(key, 'exists', 'EX', 60 * 60); // Set key with 1-hour expiry
             console.log(`New message received: ${value}`);
           }
         });
       },
     });
   };

   consumeMessagesWithRedis().catch(console.error);
   ```

In this setup, Redis is used to store the message keys with an expiration time, helping to detect duplicates efficiently. Adjust the expiration time based on your application's requirements.


-----------------------

### `log.segment.bytes` in Apache Kafka

The `log.segment.bytes` property in Apache Kafka defines the size of the log segment files in bytes. When a segment file reaches this size, a new log segment is created. This setting is important for managing log file sizes and controlling the retention and compaction of log data.

### Use Case for `log.segment.bytes`

A common use case for configuring `log.segment.bytes` is to control the size of log segments to optimize disk I/O performance and manage disk space. For example, if you have a topic with a high write throughput, smaller segment sizes might lead to more frequent segment rolling, resulting in increased disk I/O. Conversely, larger segment sizes might reduce the frequency of segment rolling but could increase the time taken for log recovery and compaction.

### Steps to Configure `log.segment.bytes`

#### 1. Modify the Kafka Broker Configuration

You can configure `log.segment.bytes` by modifying the `server.properties` file on each broker:

1. **Open the Kafka configuration file**:
    ```bash
    nano /path/to/kafka/config/server.properties
    ```

2. **Add or modify the `log.segment.bytes` property**:
    ```properties
    log.segment.bytes=1073741824  # 1 GB
    ```

3. **Save the configuration file** and exit the editor.

#### 2. Restart the Kafka Broker

For the changes to take effect, restart the Kafka broker:

```bash
sudo systemctl restart kafka
```

Alternatively, if you are running Kafka manually, stop and start the Kafka broker:

```bash
/path/to/kafka/bin/kafka-server-stop.sh
/path/to/kafka/bin/kafka-server-start.sh /path/to/kafka/config/server.properties
```

### Example Scenario

Consider a scenario where you have a Kafka topic with a high write rate and you want to optimize log segment size for better performance:

1. **Current Configuration**:
    - Default `log.segment.bytes`: 1 GB (1073741824 bytes).

2. **Observation**:
    - High I/O due to frequent segment creation.
    - High disk space usage due to large segments.

3. **Adjustment**:
    - Reduce `log.segment.bytes` to 512 MB (536870912 bytes) for more manageable segment sizes and to reduce disk I/O.

4. **Configuration Change**:
    ```properties
    log.segment.bytes=536870912  # 512 MB
    ```

5. **Expected Outcome**:
    - More frequent segment creation.
    - Improved log compaction and recovery times.
    - Better disk space management.

### Testing the Configuration

1. **Create a test topic**:
    ```bash
    /path/to/kafka/bin/kafka-topics.sh --create --topic test-segment --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
    ```

2. **Produce messages to the topic**:
    ```bash
    /path/to/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-segment
    ```
    Enter some test messages.

3. **Check the log directory**:
    Navigate to the Kafka log directory and check the size of the segment files:
    ```bash
    ls -lh /path/to/kafka/logs/test-segment-0/
    ```

> **[!IMPORTANT]**
> You can also use bulk message creation scripts covered during session.     

You should see segment files that are close to the configured `log.segment.bytes` size.

-----------------------

### 1. **Setting Up Kafka ACLs**

Before setting up ACLs, ensure that your Kafka cluster is configured to use a security protocol that supports ACLs, such as SASL or SSL.

**Kafka Broker Configuration:**

Edit the `server.properties` file of your Kafka broker to enable SASL or SSL authentication.

```properties
# Enable SASL/PLAIN authentication
listeners=SASL_PLAINTEXT://:9092
advertised.listeners=SASL_PLAINTEXT://localhost:9092
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN

# Enable SSL authentication (if required)
# listeners=SSL://:9093
# advertised.listeners=SSL://localhost:9093
# ssl.keystore.location=/path/to/keystore.jks
# ssl.keystore.password=password
# ssl.key.password=password
# ssl.truststore.location=/path/to/truststore.jks
# ssl.truststore.password=password
```

### 2. **Creating ACLs**

To create ACLs, you will use the `kafka-acls.sh` script, which is located in the `bin` directory of your Kafka installation.

#### Example 1: Allowing a User to Produce to a Topic

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal User:producer-user \
  --operation Write --topic test-topic
```

This command adds an ACL to allow `producer-user` to write to `test-topic`.

#### Example 2: Allowing a User to Consume from a Topic

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal User:consumer-user \
  --operation Read --topic test-topic --group test-group
```

This command adds an ACL to allow `consumer-user` to read from `test-topic` and join the consumer group `test-group`.

#### Example 3: Allowing a User to Create Topics

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal User:admin-user \
  --operation Create --topic test-topic
```

This command allows `admin-user` to create `test-topic`.

### 3. **Listing ACLs**

To list existing ACLs, use the following command:

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --list
```

This command will list all ACLs currently configured in the Kafka cluster.

### 4. **Removing ACLs**

To remove ACLs, you can use a command similar to the one used to add ACLs, but with the `--remove` option.

#### Example 4: Removing an ACL for a User

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --remove --allow-principal User:producer-user \
  --operation Write --topic test-topic
```

This command removes the ACL that allows `producer-user` to write to `test-topic`.

### 5. **Using Wildcards**

You can use wildcards in ACLs to apply permissions to multiple resources.

#### Example 5: Allowing a User to Produce to All Topics

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal User:producer-user \
  --operation Write --topic '*'
```

This command allows `producer-user` to write to all topics.

### 6. **Additional Operations**

Kafka ACLs support various operations, such as `Read`, `Write`, `Create`, `Delete`, `Alter`, `Describe`, and `ClusterAction`. You can apply these operations to different resources (topics, consumer groups, clusters).

#### Example 6: Allowing a User to Describe a Topic

```sh
bin/kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 \
  --add --allow-principal User:admin-user \
  --operation Describe --topic test-topic
```

This command allows `admin-user` to describe `test-topic`.
