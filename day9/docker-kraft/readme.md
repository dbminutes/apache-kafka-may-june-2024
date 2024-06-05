### 1. Create the Dockerfile

Create a file named `Dockerfile` with the following content:

```Dockerfile
# Use the official Kafka image from Confluent as the base image
FROM confluentinc/cp-kafka:latest

# Set the Kafka KRaft mode environment variables
ENV KAFKA_BROKER_ID=1
ENV CLUSTER_ID=fK-w8VSyRvaKJZgG4NME5A
ENV KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://:9092
ENV KAFKA_PROCESS_ROLES=broker,controller
ENV KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
ENV KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093
ENV KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
ENV KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT
ENV KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
ENV KAFKA_LOG_DIRS=/var/lib/kafka/data
ENV KAFKA_CONFLUENT_SUPPORT_METRICS_ENABLE=false

# Expose Kafka ports
EXPOSE 9092 9093

# Set the entrypoint to start Kafka in KRaft mode
ENTRYPOINT ["/etc/confluent/docker/run"]
```

### 2. Build the Docker Image

Open a terminal and navigate to the directory containing the Dockerfile. Then run the following command to build the Docker image:

```sh
docker build -t kafka-kraft .
```

### 3. Run the Docker Container

Run the Docker container with the following command:

```sh
docker run --name kafka-kraft -p 9092:9092 -p 9093:9093 kafka-kraft
```

### 4. Test the Kafka Setup

#### 4.1. Create a Kafka Topic

To create a Kafka topic named `test-topic`, use the following command:

```sh
docker exec kafka-kraft kafka-topics --create --topic test-topic --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092
```

#### 4.2. Produce Messages to the Topic

To produce messages to the `test-topic`, use the following command:

```sh
docker exec -it kafka-kraft kafka-console-producer --topic test-topic --bootstrap-server localhost:9092
```

Type some messages and press `Enter` after each message. For example:

```
Hello, Kafka!
This is a test message.
```

Press `Ctrl+C` to exit the producer.

#### 4.3. Consume Messages from the Topic

To consume messages from the `test-topic`, use the following command:

```sh
docker exec -it kafka-kraft kafka-console-consumer --topic test-topic --from-beginning --bootstrap-server localhost:9092
```

You should see the messages you produced earlier:

```
Hello, Kafka!
This is a test message.
```

Press `Ctrl+C` to exit the consumer.


-----------------------------

### What is Docker Compose?

Docker Compose is a tool for defining and running multi-container Docker applications. With Docker Compose, you can use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.

### Docker Compose File for Kafka in KRaft Mode

Here, we will create a Docker Compose file to set up Kafka in KRaft mode without ZooKeeper.

1. **Create a Docker Compose File**

Create a file named `docker-compose.yml` with the following content:

```yaml
version: '3.8'

services:
  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: kafka-kraft
    environment:
      KAFKA_BROKER_ID: 1
      CLUSTER_ID: fK-w8VSyRvaKJZgG4NME5A  # Ensure this is a valid base64-encoded UUID
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://:9092
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LOG_DIRS: /var/lib/kafka/data
      KAFKA_CONFLUENT_SUPPORT_METRICS_ENABLE: 'false'
    ports:
      - "9092:9092"
      - "9093:9093"
    volumes:
      - ./kafka-data:/var/lib/kafka/data
```

2. **Build and Run the Docker Compose Application**

Open a terminal, navigate to the directory containing the `docker-compose.yml` file, and run the following command to start the Kafka service:

```sh
docker-compose up -d
```

This command will start the Kafka container in detached mode.

3. **Test the Kafka Setup**

#### 3.1. Create a Kafka Topic

To create a Kafka topic named `test-topic`, use the following command:

```sh
docker-compose exec kafka-kraft kafka-topics --create --topic test-topic --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092
```

#### 3.2. Produce Messages to the Topic

To produce messages to the `test-topic`, use the following command:

```sh
docker-compose exec -it kafka-kraft kafka-console-producer --topic test-topic --bootstrap-server localhost:9092
```

Type some messages and press `Enter` after each message. For example:

```
Hello, Kafka!
This is a test message.
```

Press `Ctrl+C` to exit the producer.

#### 3.3. Consume Messages from the Topic

To consume messages from the `test-topic`, use the following command:

```sh
docker-compose exec -it kafka-kraft kafka-console-consumer --topic test-topic --from-beginning --bootstrap-server localhost:9092
```

You should see the messages you produced earlier:

```
Hello, Kafka!
This is a test message.
```

Press `Ctrl+C` to exit the consumer.

