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

# Copy any additional configuration files if needed
# COPY server.properties /etc/kafka/server.properties

# Expose Kafka ports
EXPOSE 9092 9093

# Set the entrypoint to start Kafka in KRaft mode
ENTRYPOINT ["/etc/confluent/docker/run"]
