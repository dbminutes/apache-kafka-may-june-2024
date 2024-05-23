# What is Event-Driven Architecture?

## Introduction
Event-Driven Architecture (EDA) is a software architecture paradigm that promotes the production, detection, consumption, and reaction to events. An event is a significant change in state. For example, placing an order, clicking a button, or receiving a message are all events.

## Key Concepts
- **Event**: A change in state or an update, such as a user logging in, a purchase made, or a data update.
- **Event Producer**: An entity that creates and publishes events.
- **Event Consumer**: An entity that listens for events and processes them.
- **Event Channel**: A medium through which events are transmitted from producers to consumers.

```mermaid
graph TD
    User[User] -->|Generates Event| EventProducer[Event Producer]
    EventProducer -->|Sends Event| EventBroker[Event Broker]
    EventBroker -->|Distributes Event| EventConsumer1[Event Consumer 1]
    EventBroker -->|Distributes Event| EventConsumer2[Event Consumer 2]
    EventConsumer1 -->|Processes Event| Service1[Service 1]
    EventConsumer2 -->|Processes Event| Service2[Service 2]
    Service1 -->|Generates New Event| EventProducer2[Event Producer 2]
    EventProducer2 -->|Sends Event| EventBroker
    EventBroker -->|Distributes Event| EventConsumer3[Event Consumer 3]
    EventConsumer3 -->|Processes Event| Service3[Service 3]

    subgraph "Event Producer and Consumer"
        EventProducer
        EventProducer2
        EventConsumer1
        EventConsumer2
        EventConsumer3
    end

    subgraph "Services"
        Service1
        Service2
        Service3
    end

    subgraph "Event Broker"
        EventBroker
    end
```

## How EDA Works
1. **Event Generation**: An event producer generates an event and sends it to an event channel.
2. **Event Transmission**: The event channel transmits the event to interested consumers.
3. **Event Processing**: Event consumers process the event, often leading to the generation of new events.


### Step 1: Event Producers
```mermaid
graph TD;
    A(User Actions) --> B(Event Producers);
    C(System Events) --> B;
    D(External Systems) --> B;
```

### Step 2: Event Channel
```mermaid
graph TD;
    B(Event Producers) --> E(Event Channel);
```

### Step 3: Event Processing
```mermaid
graph TD;
    E(Event Channel) --> F(Event Consumers);
```

### Step 4: Event Consumers
```mermaid
graph TD;
    F(Event Consumers) --> G(Perform Actions/Trigger Workflows);
```

### Step 5: Event Store (Optional)
```mermaid
graph TD;
    E(Event Channel) --> H(Event Store);
```

### Step 6: Event Processing Logic
```mermaid
graph TD;
    F(Event Consumers) --> I(Event Processing Logic);
```

### Step 7: System Reaction
```mermaid
graph TD;
    I(Event Processing Logic) --> J(System Reaction/State Change);
```

### Full Diagram

```mermaid
graph TD;
    A(User Actions) --> B(Event Producers);
    C(System Events) --> B;
    D(External Systems) --> B;
    B --> E(Event Channel);
    E --> F(Event Consumers);
    E --> H(Event Store);
    F --> G(Perform Actions/Trigger Workflows);
    F --> I(Event Processing Logic);
    I --> J(System Reaction/State Change);
```


## Real-World Examples
- **E-commerce Systems**: Tracking orders, inventory changes, and user actions.
- **Banking Systems**: Monitoring transactions, fraud detection, and account updates.
- **IoT Applications**: Reacting to sensor data, device updates, and environmental changes.
