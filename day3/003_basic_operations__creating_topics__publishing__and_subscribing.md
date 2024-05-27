# Basic Operations: Creating Topics, Publishing, and Subscribing


### Basic Kafka Operations

1. **Create a Topic:**

   ```sh
   /usr/local/kafka/bin/kafka-topics.sh --create --topic test --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1
   ```

2. **List Topics:**

   ```sh
   /usr/local/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
   ```

3. **Produce Messages:**

   ```sh
   /usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
   ```

4. **Consume Messages:**

   ```sh
   /usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
   ```

5. **Start Producers (Optional)**
We can start a producer to send some messages to the topic.

```bash
#!/bin/bash

# Start a producer
$KAFKA_HOME/bin/kafka-console-producer.sh --topic my-topic --bootstrap-server localhost:9092
```

You can type messages into the console and press Enter to send them to the topic.

6. **Start Consumers in a Consumer Group**
We will start multiple consumers, all part of the same consumer group.

```bash
#!/bin/bash

# Start first consumer in group "my-consumer-group"
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --group my-consumer-group --from-beginning &

# Start second consumer in the same group
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --group my-consumer-group --from-beginning &
```

### Putting It All Together
Here’s a complete bash script that creates a topic and starts multiple consumers in the same consumer group:

```bash
#!/bin/bash

# Create a topic
$KAFKA_HOME/bin/kafka-topics.sh --create --topic my-topic --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

# Start first consumer in group "my-consumer-group"
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --group my-consumer-group --from-beginning &

# Start second consumer in the same group
$KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic --group my-consumer-group --from-beginning &

# Optionally, start a producer to send messages to the topic
echo "Starting producer. Type messages and press Enter to send to the topic."
$KAFKA_HOME/bin/kafka-console-producer.sh --topic my-topic --bootstrap-server localhost:9092
```

### Notes:
- **`--from-beginning`**: This option makes the consumers read messages from the beginning of the topic. If you want consumers to start from the latest messages, you can omit this option.
- **Background Process (`&`)**: Running consumers in the background allows you to start multiple consumers from the same script.
- **Environment Variable**: `$KAFKA_HOME` should point to your Kafka installation directory. You can replace `$KAFKA_HOME/bin/` with the actual path to your Kafka `bin` directory if it's not set.
