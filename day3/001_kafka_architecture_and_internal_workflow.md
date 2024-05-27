# Kafka Architecture and Internal Workflow

### Kafka Data Writing Workflow

#### Load Balancer
1. **Client Request**: The client application sends a write request to the load balancer.
2. **Load Balancer**: The load balancer forwards the request to one of the Kafka brokers based on the load-balancing strategy (e.g., round-robin, least connections).

#### Write Operation with Idempotent Settings

1. **Producer Configuration**: Configure the Kafka producer with idempotence enabled (`enable.idempotence=true`). This ensures that duplicate records are not produced in case of retries.

##### Subflow 1: Idempotent Producer

2. **Producer Send**: The producer sends a message to the Kafka broker with a unique `producerId` and `sequenceNumber`.
3. **Broker Acknowledgment**: The Kafka broker acknowledges the receipt of the message, ensuring exactly-once delivery semantics.
4. **Broker Write**: The broker writes the message to the appropriate partition in the Kafka log in an append-only manner.

##### Subflow 2: Non-Idempotent Producer

2. **Producer Send**: The producer sends a message to the Kafka broker without idempotence settings.
3. **Broker Acknowledgment**: The Kafka broker acknowledges the receipt of the message.
4. **Broker Write**: The broker writes the message to the appropriate partition in the Kafka log in an append-only manner. In this case, if a retry occurs, there might be duplicate messages.

#### Append-Only Architecture
1. **Log Append**: The message is appended to the end of the log for the corresponding partition.
2. **Replication**: The message is replicated to other brokers to ensure fault tolerance and high availability.

### Kafka Data Reading Workflow

#### Load Balancer
1. **Client Request**: The client application sends a read request to the load balancer.
2. **Load Balancer**: The load balancer forwards the request to one of the Kafka brokers based on the load-balancing strategy.

#### Read Operation

1. **Consumer Configuration**: Configure the Kafka consumer with appropriate settings for offset management and failure handling.
   - `auto.offset.reset`: Controls the behavior when there is no initial offset in Kafka or if the current offset does not exist anymore (e.g., `earliest` or `latest`).
   - `enable.auto.commit`: If set to `false`, the application manually commits offsets to handle in-flight messages and failures.

2. **Consumer Poll**: The consumer polls the Kafka broker for new messages.
3. **Offset Management**:
   - **Manual Offset Control**: The consumer processes messages and commits offsets manually after successful processing.
   - **Automatic Offset Control**: If `enable.auto.commit` is set to `true`, offsets are committed automatically at regular intervals.

4. **Failure Handling**:
   - **Retry Mechanism**: If a failure occurs during message processing, the consumer can retry processing the message based on a retry strategy.
   - **Dead Letter Queue**: Messages that cannot be processed after a certain number of retries are sent to a dead letter queue for further analysis.

5. **In-Flight Messages**:
   - **Buffering**: Maintain a buffer of in-flight messages that are being processed.
   - **Acknowledge on Success**: Only acknowledge the messages once they are successfully processed and offsets are committed.
