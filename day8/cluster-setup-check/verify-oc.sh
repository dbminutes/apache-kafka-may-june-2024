#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if an image exists locally
image_exists() {
  podman images --format "{{.Repository}}:{{.Tag}}" | grep -q "$1:$2"
}

# Check if oc is installed
if ! command_exists oc; then
  echo "Error: oc is not installed."
  exit 1
fi

# Check if podman is installed
if ! command_exists podman; then
  echo "Error: podman is not installed."
  exit 1
fi

# Pull the Kafka and Zookeeper images using podman if they do not exist
KAFKA_IMAGE="bitnami/kafka"
ZOOKEEPER_IMAGE="bitnami/zookeeper"
TAG="latest"

if ! image_exists $KAFKA_IMAGE $TAG; then
  echo "Pulling Kafka image using podman..."
  podman pull $KAFKA_IMAGE:$TAG
  if [ $? -ne 0 ]; then
    echo "Error: Failed to pull Kafka image."
    exit 1
  fi
else
  echo "Kafka image already exists locally."
fi

if ! image_exists $ZOOKEEPER_IMAGE $TAG; then
  echo "Pulling Zookeeper image using podman..."
  podman pull $ZOOKEEPER_IMAGE:$TAG
  if [ $? -ne 0 ]; then
    echo "Error: Failed to pull Zookeeper image."
    exit 1
  fi
else
  echo "Zookeeper image already exists locally."
fi

# Log in to the OpenShift cluster
echo "Logging in to OpenShift cluster..."
oc login -u developer https://api.crc.testing:6443

# Check if login was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to log in to OpenShift cluster."
  exit 1
fi

# Define project name
PROJECT_NAME="kafka-project"

# Check if the project exists
oc get project $PROJECT_NAME &>/dev/null

if [ $? -eq 0 ]; then
  echo "Project $PROJECT_NAME already exists. Deleting it..."
  oc delete project $PROJECT_NAME

  # Wait for 10 seconds with a counter before creating a new project
  echo "Waiting for 10 seconds before creating a new project..."
  for i in {10..1}; do
    echo "$i seconds remaining..."
    sleep 1
  done

  echo "Waiting for project $PROJECT_NAME to be deleted..."
  while oc get project $PROJECT_NAME &>/dev/null; do
    sleep 1
  done
fi

# Create a new project
echo "Creating new project: $PROJECT_NAME"
oc new-project $PROJECT_NAME

# Check if the project was created successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to create project $PROJECT_NAME."
  exit 1
fi

# Apply Kafka and Zookeeper deployment YAML
echo "Applying Kafka and Zookeeper deployment YAML..."
oc apply -f kafka-deployment.yaml

# Wait for the Zookeeper deployment to complete
echo "Waiting for Zookeeper application to be ready..."
oc rollout status deployment/zookeeper

# Wait for the Kafka deployment to complete
echo "Waiting for Kafka application to be ready..."
oc rollout status deployment/my-kafka

# Verify if the Kafka deployment is running
KAFKA_STATUS=$(oc get pods | grep "my-kafka" | grep "Running")

if [ -z "$KAFKA_STATUS" ]; then
  echo "Error: Kafka application is not running properly."
  echo "Fetching Kafka pod logs..."
  KAFKA_POD=$(oc get pods -l app=my-kafka -o jsonpath="{.items[0].metadata.name}")
  
  echo "Logs of Kafka pod:"
  oc logs $KAFKA_POD
  
  echo "Describing Kafka pod..."
  oc describe pod $KAFKA_POD
  
  echo "Displaying events..."
  oc get events
  
  exit 1
fi

echo "Kafka application is running properly."

# Wait for 1 minute before creating the topic, with a countdown
echo "Waiting for 60 seconds before creating the Kafka topic..."
for i in {60..1}; do
  echo -ne "$i\033[0K\r"
  sleep 1
done

# Create a Kafka topic
TOPIC_NAME="test-topic"
echo "Creating Kafka topic: $TOPIC_NAME"
oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  kafka-topics.sh --create --topic $TOPIC_NAME --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# Check if the topic was created successfully
TOPIC_STATUS=$(oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  kafka-topics.sh --list --bootstrap-server localhost:9092 | grep $TOPIC_NAME)

if [ -z "$TOPIC_STATUS" ]; then
  echo "Error: Failed to create Kafka topic $TOPIC_NAME."
  exit 1
fi

echo "Kafka topic $TOPIC_NAME created successfully."

# Produce a message to the Kafka topic
MESSAGE="Hello, Kafka!"
echo "Producing message to Kafka topic: $MESSAGE"
oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  kafka-console-producer.sh --topic $TOPIC_NAME --bootstrap-server localhost:9092 <<< "$MESSAGE"

# Consume the message from the Kafka topic
echo "Consuming message from Kafka topic"
CONSUMED_MESSAGE=$(oc exec $(oc get pods -o jsonpath="{.items[0].metadata.name}" -l app=my-kafka) -- \
  kafka-console-consumer.sh --topic $TOPIC_NAME --bootstrap-server localhost:9092 --from-beginning --timeout-ms 10000 | grep "$MESSAGE")

if [ -z "$CONSUMED_MESSAGE" ]; then
  echo "Error: Failed to consume message from Kafka topic $TOPIC_NAME."
  exit 1
fi

echo "Successfully consumed message from Kafka topic: $CONSUMED_MESSAGE"

echo "OC installation and Kafka deployment have been verified successfully."

exit 0
