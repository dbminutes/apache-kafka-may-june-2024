# Creating and Managing Kafka Clusters on Redhat OpenShift Streams (Using multiple operators)


#### Introduction

Red Hat OpenShift Streams for Apache Kafka simplifies the deployment, management, and scaling of Kafka clusters on OpenShift. By leveraging the Operator framework, users can automate many aspects of Kafka cluster operations, ensuring high availability, security, and scalability.

#### Prerequisites

1. A running OpenShift cluster.
2. OpenShift CLI (oc) installed and configured.
3. Access to the OpenShift OperatorHub.

#### Step-by-Step Guide

##### Step 1: Access the OpenShift Console

1. Log in to your OpenShift cluster using the OpenShift console URL.
2. Navigate to the OpenShift web console.

##### Step 2: Install the Kafka Operator

1. In the OpenShift web console, navigate to the **OperatorHub** under the **Operators** section.
2. Search for "Kafka" or "Red Hat OpenShift Streams for Apache Kafka".
3. Select the Kafka Operator provided by Red Hat.
4. Click on the **Install** button.
5. Choose the installation mode (typically "All namespaces" for cluster-wide access).
6. Review and accept the installation parameters.
7. Click **Install** to deploy the Kafka Operator.

##### Step 3: Create a Kafka Cluster

1. After the Operator is installed, navigate to the **Installed Operators** section under **Operators**.
2. Select the Kafka Operator.
3. Click on the **Create Instance** button to create a new Kafka cluster.
4. Fill in the required details such as the cluster name, namespace, and configurations (e.g., number of brokers, storage configuration).
5. Click **Create** to deploy the Kafka cluster.

##### Step 4: Configure Kafka Topics

1. Navigate to the **Kafka** resource under the Kafka Operator.
2. Select the Kafka cluster you created.
3. Click on the **Topics** tab.
4. Click **Create Topic**.
5. Provide the topic name and configure settings like partitions and replication factor.
6. Click **Create** to add the topic.

##### Step 5: Manage Users and Access

1. Under the Kafka cluster, navigate to the **KafkaUser** resource.
2. Click **Create KafkaUser**.
3. Fill in the user details, including username and authentication type.
4. Configure ACLs (Access Control Lists) for the user to define their permissions on topics and consumer groups.
5. Click **Create** to add the user.

##### Step 6: Producing and Consuming Messages

1. **Producing Messages**:
   - Use Kafka client libraries in your preferred programming language (e.g., Java, Python) to connect to the Kafka cluster and produce messages to topics.
   - Example (Java):
     ```java
     Properties props = new Properties();
     props.put("bootstrap.servers", "your-kafka-bootstrap-server");
     props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
     props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

     Producer<String, String> producer = new KafkaProducer<>(props);
     producer.send(new ProducerRecord<>("your-topic", "key", "value"));
     producer.close();
     ```

2. **Consuming Messages**:
   - Use Kafka client libraries to connect to the Kafka cluster and consume messages from topics.
   - Example (Java):
     ```java
     Properties props = new Properties();
     props.put("bootstrap.servers", "your-kafka-bootstrap-server");
     props.put("group.id", "your-consumer-group");
     props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
     props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");

     Consumer<String, String> consumer = new KafkaConsumer<>(props);
     consumer.subscribe(Collections.singletonList("your-topic"));

     while (true) {
         ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
         for (ConsumerRecord<String, String> record : records) {
             System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
         }
     }
     ```

##### Step 7: Monitoring and Management

1. The Kafka Operator provides built-in monitoring capabilities using Prometheus and Grafana.
2. Navigate to the **Monitoring** section in the OpenShift console to view metrics and alerts.
3. Set up dashboards and alerts to monitor the health and performance of your Kafka cluster.

##### Step 8: Scaling and Upgrading

1. To scale your Kafka cluster, navigate to the **Kafka** resource and update the number of brokers or resources allocated.
2. Apply the changes, and the Kafka Operator will handle the scaling process.
3. For upgrades, check for new versions of the Kafka Operator and follow the instructions to update the Operator and Kafka cluster.
