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
