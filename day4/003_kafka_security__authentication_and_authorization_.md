# Kafka Security (Authentication and Authorization)

>[!IMPORTANT]
> Before executing commands on your system, it's important to understand the concepts of security and authorization. Some commands may vary depending on your specific system setup.

Kafka security is crucial to ensure data integrity, confidentiality, and reliable operation. 

### Prerequisites
- Basic knowledge  SSL and tools related to handling certificates and Keys using openssl and keytool

### Step 1: Set Up SSL for Kafka

**Generate SSL Certificates:**
1. Create a Certificate Authority (CA):
    ```sh
    openssl req -new -x509 -keyout ca-key -out ca-cert -days 365
    ```

2. Generate a key for the Kafka broker:
    ```sh
    keytool -keystore kafka.server.keystore.jks -alias localhost -keyalg RSA -genkey
    ```

3. Generate a certificate signing request (CSR):
    ```sh
    keytool -keystore kafka.server.keystore.jks -alias localhost -certreq -file cert-file
    ```

4. Sign the CSR with your CA:
    ```sh
    openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial
    ```

5. Import the CA and the signed certificate into the broker keystore:
    ```sh
    keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert
    keytool -keystore kafka.server.keystore.jks -alias localhost -import -file cert-signed
    ```

6. Create a truststore and import the CA:
    ```sh
    keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert
    ```

### Step 2: Configure Kafka Broker

Edit the `server.properties` file in your Kafka config directory:

```properties
listeners=SSL://your.host.name:9093
advertised.listeners=SSL://your.host.name:9093
ssl.keystore.location=/path/to/kafka.server.keystore.jks
ssl.keystore.password=your_keystore_password
ssl.key.password=your_key_password
ssl.truststore.location=/path/to/kafka.server.truststore.jks
ssl.truststore.password=your_truststore_password
ssl.client.auth=required
```

### Step 3: Configure SSL for Kafka Clients

Create a `client-ssl.properties` file:

```properties
security.protocol=SSL
ssl.keystore.location=/path/to/kafka.client.keystore.jks
ssl.keystore.password=your_keystore_password
ssl.key.password=your_key_password
ssl.truststore.location=/path/to/kafka.client.truststore.jks
ssl.truststore.password=your_truststore_password
```

### Step 4: Set Up SASL Authentication

**Create JAAS Configuration:**
For Kafka broker, create `kafka_server_jaas.conf`:

```plaintext
KafkaServer {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="admin"
   password="admin-secret"
   user_admin="admin-secret"
   user_alice="alice-secret"
   user_bob="bob-secret";
};
```

**Update Broker Configuration:**
Add the following to `server.properties`:

```properties
listeners=SASL_SSL://your.host.name:9094
advertised.listeners=SASL_SSL://your.host.name:9094
security.inter.broker.protocol=SASL_SSL
sasl.enabled.mechanisms=PLAIN
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.jaas.config=file:/path/to/kafka_server_jaas.conf
```

### Step 5: Configure Authorization

Kafka uses Access Control Lists (ACLs) for authorization. You can manage ACLs using the `kafka-acls.sh` script.

**Grant User Access:**
```sh
kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:alice --operation Read --topic test-topic
kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --add --allow-principal User:alice --operation Write --topic test-topic
```

**List ACLs:**
```sh
kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --list --topic test-topic
```

**Remove ACLs:**
```sh
kafka-acls.sh --authorizer-properties zookeeper.connect=localhost:2181 --remove --allow-principal User:alice --operation Write --topic test-topic
```

### Step 6: Testing Authentication and Authorization

**Test SSL Connectivity:**
```sh
kafka-console-producer.sh --broker-list your.host.name:9093 --topic test-topic --producer.config client-ssl.properties
```

**Test SASL Authentication:**
Create a `client_sasl_jaas.conf` for the client:

```plaintext
KafkaClient {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="alice"
   password="alice-secret";
};
```

Then test with the following configuration:
```properties
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=file:/path/to/client_sasl_jaas.conf
ssl.truststore.location=/path/to/kafka.client.truststore.jks
ssl.truststore.password=your_truststore_password
```

Run the producer with the SASL configuration:
```sh
kafka-console-producer.sh --broker-list your.host.name:9094 --topic test-topic --producer.config client_sasl_ssl.properties
```


