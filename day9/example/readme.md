### Step 1: Python Producer Script

Create a Python script to produce messages to the Kafka topic.

```python
from kafka import KafkaProducer

# Initialize the Kafka producer
producer = KafkaProducer(bootstrap_servers='localhost:9092')

# Send messages to the topic
for i in range(10):
    message = f'Message {i}'
    producer.send('test-topic', value=message.encode('utf-8'))
    print(f'Sent: {message}')

# Ensure all messages are sent
producer.flush()

# Close the producer
producer.close()
```

### Step 2: Python Consumer Script

Create a Python script to consume messages from the Kafka topic.

```python
from kafka import KafkaConsumer

# Initialize the Kafka consumer
consumer = KafkaConsumer(
    'test-topic',
    bootstrap_servers='localhost:9092',
    auto_offset_reset='earliest',
    group_id='test-group',
    consumer_timeout_ms=1000
)

# Consume messages from the topic
for message in consumer:
    print(f"Received: {message.value.decode('utf-8')}")

# Close the consumer
consumer.close()
```

### Running the Scripts

Run the producer script first to send messages to the Kafka topic:

```bash
python producer.py
```

Then, run the consumer script to read the messages:

```bash
python consumer.py
```

### Additional Configurations

- **Error Handling**: Add error handling to manage exceptions and retries.
- **Serialization/Deserialization**: Use serializers for more complex message formats.
- **Security**: Configure SSL and SASL for secure communication if needed.
- **Monitoring**: Implement logging and monitoring for production readiness.

