# Integrating Kafka with OpenShift

Running Kafka on OpenShift can be efficiently managed using the Strimzi Kafka Operator, which simplifies the deployment, management, and scaling of Kafka clusters on Kubernetes and OpenShift. 
### Step 1: Set Up OpenShift

1. **Login to OpenShift Cluster:**
   ```sh
   oc login <your-openshift-cluster-url>
   ```

2. **Create a New Project:**
   ```sh
   oc new-project kafka-project
   ```

### Step 2: Install Strimzi Kafka Operator

1. **Create a Namespace (if not already created):**
   ```sh
   oc create namespace kafka
   ```

2. **Install the Strimzi Kafka Operator:**
   - Apply the Strimzi installation files from the official repository:
     ```sh
     oc apply -f https://strimzi.io/install/latest?namespace=kafka -n kafka
     ```

3. **Verify the Installation:**
   - Check if the Strimzi Cluster Operator is running:
     ```sh
     oc get pods -n kafka
     ```

### Step 3: Deploy Kafka Cluster

1. **Create a Kafka Cluster Configuration File (`kafka-cluster.yaml`):**
   ```yaml
   apiVersion: kafka.strimzi.io/v1beta2
   kind: Kafka
   metadata:
     name: my-cluster
     namespace: kafka
   spec:
     kafka:
       version: 3.3.1
       replicas: 3
       listeners:
         - name: plain
           port: 9092
           type: internal
           tls: false
         - name: tls
           port: 9093
           type: internal
           tls: true
       config:
         offsets.topic.replication.factor: 3
         transaction.state.log.replication.factor: 3
         transaction.state.log.min.isr: 2
         log.message.format.version: "3.3.1"
       storage:
         type: ephemeral
     zookeeper:
       replicas: 3
       storage:
         type: ephemeral
     entityOperator:
       topicOperator: {}
       userOperator: {}
   ```

2. **Apply the Kafka Cluster Configuration:**
   ```sh
   oc apply -f kafka-cluster.yaml
   ```

3. **Verify the Kafka Cluster Deployment:**
   - Check if the Kafka and Zookeeper pods are running:
     ```sh
     oc get pods -n kafka
     ```

### Step 4: Expose Kafka Outside OpenShift (Optional)

1. **Create a Route for Kafka:**
   ```yaml
   apiVersion: route.openshift.io/v1
   kind: Route
   metadata:
     name: my-cluster-kafka-route
     namespace: kafka
   spec:
     host: my-cluster-kafka-route-myproject.<your-openshift-cluster-url>
     to:
       kind: Service
       name: my-cluster-kafka-bootstrap
   ```

2. **Apply the Route Configuration:**
   ```sh
   oc apply -f kafka-route.yaml
   ```

### Step 5: Using Kafka

1. **Create a Kafka Topic:**
   ```yaml
   apiVersion: kafka.strimzi.io/v1beta2
   kind: KafkaTopic
   metadata:
     name: my-topic
     namespace: kafka
     labels:
       strimzi.io/cluster: my-cluster
   spec:
     partitions: 3
     replicas: 3
   ```

2. **Apply the Kafka Topic Configuration:**
   ```sh
   oc apply -f kafka-topic.yaml
   ```

3. **Verify the Kafka Topic:**
   - Check if the topic is created:
     ```sh
     oc get kafkatopics -n kafka
     ```

### Step 6: Access Kafka from an Application

- You can now configure your applications to connect to the Kafka cluster using the service name `my-cluster-kafka-bootstrap.kafka:9092` for internal communication or the route created for external access.

