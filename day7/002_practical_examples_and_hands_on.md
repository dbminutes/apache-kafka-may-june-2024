# Practical Examples and Hands-on

Apache Kafka is a distributed streaming platform used for building real-time data pipelines and streaming applications. Connecting an application to a Kafka cluster involves setting up the necessary configurations and using Kafka clients to produce and consume messages. 

### Prerequisites
- Apache Kafka installed and running.
- Basic understanding of Kafka concepts such as producers, consumers, topics, and brokers.
- A programming environment set up for your preferred language (e.g., Java, Python, or Node.js).

### Step 1: Connecting a Java Application to Kafka

1. **Add Kafka Dependencies:**
   - Add the Kafka client library to your `pom.xml` (Maven) or `build.gradle` (Gradle).

   **Maven:**
   ```xml
   <dependency>
       <groupId>org.apache.kafka</groupId>
       <artifactId>kafka-clients</artifactId>
       <version>2.8.0</version>
   </dependency>
   ```

   **Gradle:**
   ```groovy
   implementation 'org.apache.kafka:kafka-clients:2.8.0'
   ```

2. **Produce Messages:**
   ```java
   import org.apache.kafka.clients.producer.KafkaProducer;
   import org.apache.kafka.clients.producer.ProducerRecord;
   import org.apache.kafka.clients.producer.ProducerConfig;
   import org.apache.kafka.common.serialization.StringSerializer;

   import java.util.Properties;

   public class KafkaProducerExample {
       public static void main(String[] args) {
           Properties props = new Properties();
           props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
           props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
           props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

           KafkaProducer<String, String> producer = new KafkaProducer<>(props);

           for (int i = 0; i < 10; i++) {
               producer.send(new ProducerRecord<>("test-topic", Integer.toString(i), "message-" + i));
           }

           producer.close();
       }
   }
   ```

3. **Consume Messages:**
   ```java
   import org.apache.kafka.clients.consumer.KafkaConsumer;
   import org.apache.kafka.clients.consumer.ConsumerRecords;
   import org.apache.kafka.clients.consumer.ConsumerConfig;
   import org.apache.kafka.clients.consumer.ConsumerRecord;
   import org.apache.kafka.common.serialization.StringDeserializer;

   import java.util.Collections;
   import java.util.Properties;

   public class KafkaConsumerExample {
       public static void main(String[] args) {
           Properties props = new Properties();
           props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
           props.put(ConsumerConfig.GROUP_ID_CONFIG, "test-group");
           props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
           props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

           KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
           consumer.subscribe(Collections.singletonList("test-topic"));

           while (true) {
               ConsumerRecords<String, String> records = consumer.poll(100);
               for (ConsumerRecord<String, String> record : records) {
                   System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
               }
           }
       }
   }
   ```

### Step 2: Connecting a Python Application to Kafka

1. **Install Kafka Python Library:**
   ```bash
   pip install kafka-python
   ```

2. **Produce Messages:**
   ```python
   from kafka import KafkaProducer

   producer = KafkaProducer(bootstrap_servers='localhost:9092')

   for i in range(10):
       producer.send('test-topic', key=bytes(str(i), 'utf-8'), value=bytes(f'message-{i}', 'utf-8'))

   producer.close()
   ```

3. **Consume Messages:**
   ```python
   from kafka import KafkaConsumer

   consumer = KafkaConsumer('test-topic', group_id='test-group', bootstrap_servers='localhost:9092')

   for message in consumer:
       print(f"offset = {message.offset}, key = {message.key}, value = {message.value}")
   ```

### Step 3: Connecting a Node.js Application to Kafka

1. **Install Kafka Node Library:**
   ```bash
   npm install kafka-node
   ```

2. **Produce Messages:**
   ```javascript
   const kafka = require('kafka-node');
   const Producer = kafka.Producer;
   const client = new kafka.KafkaClient({ kafkaHost: 'localhost:9092' });
   const producer = new Producer(client);

   const payloads = Array.from({ length: 10 }, (_, i) => ({
       topic: 'test-topic',
       messages: `message-${i}`,
       key: `${i}`,
   }));

   producer.on('ready', function () {
       producer.send(payloads, function (err, data) {
           console.log(data);
       });
   });

   producer.on('error', function (err) {
       console.log('Error:', err);
   });
   ```

3. **Consume Messages:**
   ```javascript
   const kafka = require('kafka-node');
   const Consumer = kafka.Consumer;
   const client = new kafka.KafkaClient({ kafkaHost: 'localhost:9092' });
   const consumer = new Consumer(client, [{ topic: 'test-topic', partition: 0 }], { autoCommit: true });

   consumer.on('message', function (message) {
       console.log(`offset = ${message.offset}, key = ${message.key}, value = ${message.value}`);
   });

   consumer.on('error', function (err) {
       console.log('Error:', err);
   });
   ```
