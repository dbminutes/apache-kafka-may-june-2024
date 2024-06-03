# Monitoring and Scaling Kafka Clusters


Managing and monitoring Kafka clusters is crucial for ensuring high availability, performance, and reliability. Red Hat OpenShift Streams for Apache Kafka provides robust tools for monitoring and scaling Kafka clusters. 

#### Prerequisites

1. A running OpenShift cluster.
2. OpenShift CLI (`oc`) installed and configured.
3. Kafka Operator installed on your OpenShift cluster.
4. A deployed Kafka cluster on OpenShift.

#### Monitoring Kafka Clusters

##### Step 1: Setting Up Prometheus

1. **Install Prometheus Operator**:
   - Navigate to the **OperatorHub** in the OpenShift web console.
   - Search for "Prometheus" and install the Prometheus Operator.

2. **Deploy Prometheus**:
   - Once the Prometheus Operator is installed, navigate to the **Installed Operators** section.
   - Select the Prometheus Operator.
   - Click **Create Instance** to deploy a Prometheus instance.
   - Configure the Prometheus instance, including the namespace, and create the instance.

3. **Configure ServiceMonitor for Kafka**:
   - Create a `ServiceMonitor` resource to scrape metrics from the Kafka cluster.
   - Use the following YAML as a template and apply it using `oc apply -f <filename>.yaml`:
     ```yaml
     apiVersion: monitoring.coreos.com/v1
     kind: ServiceMonitor
     metadata:
       name: kafka-servicemonitor
       namespace: your-namespace
     spec:
       selector:
         matchLabels:
           app: kafka
       endpoints:
       - port: metrics
     ```

##### Step 2: Setting Up Grafana

1. **Install Grafana Operator**:
   - Navigate to the **OperatorHub** in the OpenShift web console.
   - Search for "Grafana" and install the Grafana Operator.

2. **Deploy Grafana**:
   - Once the Grafana Operator is installed, navigate to the **Installed Operators** section.
   - Select the Grafana Operator.
   - Click **Create Instance** to deploy a Grafana instance.
   - Configure the Grafana instance, including the namespace, and create the instance.

3. **Configure Grafana to Use Prometheus**:
   - Access the Grafana UI through the OpenShift console.
   - Add Prometheus as a data source in Grafana:
     - Go to **Configuration > Data Sources**.
     - Click **Add data source** and select **Prometheus**.
     - Configure the URL to point to your Prometheus instance (e.g., `http://prometheus-operated.your-namespace.svc:9090`).
     - Click **Save & Test** to verify the connection.

4. **Import Kafka Dashboards**:
   - Import pre-built Kafka dashboards from Grafana's dashboard repository.
   - In Grafana, go to **Dashboards > Import**.
   - Use dashboard IDs such as `7589` for Kafka Overview and `10991` for Kafka Broker Overview.
   - Configure the data source to use the Prometheus instance you added earlier.

#### Scaling Kafka Clusters

##### Step 1: Scaling Kafka Brokers

1. **Access the Kafka Resource**:
   - Navigate to the **Installed Operators** section in the OpenShift web console.
   - Select the Kafka Operator and then the Kafka resource you want to scale.

2. **Update the Kafka Cluster Configuration**:
   - Edit the Kafka cluster resource to change the number of brokers.
   - For example, to scale up from 3 to 5 brokers, modify the `spec.kafka.replicas` field in the Kafka resource YAML:
     ```yaml
     apiVersion: kafka.strimzi.io/v1beta1
     kind: Kafka
     metadata:
       name: my-cluster
       namespace: your-namespace
     spec:
       kafka:
         replicas: 5
         storage:
           type: jbod
           volumes:
           - id: 0
             type: persistent-claim
             size: 100Gi
             deleteClaim: false
       zookeeper:
         replicas: 3
         storage:
           type: persistent-claim
           size: 100Gi
           deleteClaim: false
       entityOperator:
         topicOperator: {}
         userOperator: {}
     ```
   - Apply the changes using `oc apply -f <filename>.yaml`.

3. **Monitor the Scaling Process**:
   - Monitor the status of the Kafka cluster using the OpenShift console or CLI.
   - Ensure that the new brokers are added and become part of the Kafka cluster.

##### Step 2: Scaling Kafka Topics

1. **Increase Partitions**:
   - Increasing the number of partitions for a topic can help distribute the load more evenly.
   - Use the Kafka CLI or a Kafka client to increase the partitions:
     ```bash
     kafka-topics.sh --alter --topic your-topic --partitions 10 --bootstrap-server your-kafka-bootstrap-server
     ```

2. **Monitor Topic Performance**:
   - Use Grafana dashboards to monitor the performance of Kafka topics.
   - Look for metrics such as message throughput, partition distribution, and consumer lag to determine if scaling is needed.
