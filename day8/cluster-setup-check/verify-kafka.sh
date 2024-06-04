#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if oc is installed
if ! command_exists oc; then
  echo "Error: oc is not installed."
  exit 1
fi

# Log in to the OpenShift cluster
echo "Logging in to OpenShift cluster..."
oc login -u developer https://api.crc.testing:6443

# Check if login was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to log in to OpenShift cluster."
  exit 1
fi

# Define variables
PROJECT_NAME="kafka-test-project"
TOPIC_NAME="test-topic"
MESSAGE="Hello, Kafka!"

# Switch to the specified project
echo "Switching to project: $PROJECT_NAME"
oc project $PROJECT_NAME

# Produce a message to the Kafka topic
echo "Producing message to Kafka topic: $MESSAGE"
oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  kafka-console-producer.sh --topic $TOPIC_NAME --bootstrap-server localhost:9092 <<< "$MESSAGE"

# Consume the message from the Kafka topic with a timeout
echo "Consuming message from Kafka topic with timeout"
CONSUMED_MESSAGE=$(oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  timeout 10 kafka-console-consumer.sh --topic $TOPIC_NAME --bootstrap-server localhost:9092 --from-beginning --max-messages 1 | grep "$MESSAGE")

if [ -z "$CONSUMED_MESSAGE" ]; then
  echo "Error: Failed to consume message from Kafka topic $TOPIC_NAME."
  exit 1
fi

echo "Successfully consumed message from Kafka topic: $CONSUMED_MESSAGE"

exit 0
