import os
import re

# Define the modified agenda as a list of dictionaries without the first topic
agenda = [
    {
        "day": "Day 1",
        "topics": [
            "What is Event-Driven Architecture?",
            "Benefits and Challenges of Event-Driven Architecture",
            "Key Components and Patterns"
        ]
    },
    {
        "day": "Day 2",
        "topics": [
            "What is Apache Kafka?",
            "Core Components of Kafka: Producers, Consumers, Brokers, Topics",
            "Kafka Ecosystem and Common Use Cases"
        ]
    },
    {
        "day": "Day 3",
        "topics": [
            "Kafka Architecture and Internal Workflow",
            "Setting up Kafka Environment (Installation & Configuration)",
            "Basic Operations: Creating Topics, Publishing, and Subscribing"
        ]
    },
    {
        "day": "Day 4",
        "topics": [
            "Kafka Streams and Kafka Connect",
            "Advanced Configurations and Tuning Kafka for Performance",
            "Kafka Security (Authentication and Authorization)"
        ]
    },
    {
        "day": "Day 5",
        "topics": [
            "Introduction to Red Hat OpenShift",
            "Key Features of OpenShift Application Services",
            "Integrating Kafka with OpenShift"
        ]
    },
    {
        "day": "Day 6",
        "topics": [
            "Introduction to OpenShift Streams for Kafka",
            "Creating and Managing Kafka Clusters on OpenShift Streams",
            "Monitoring and Scaling Kafka Clusters"
        ]
    },
    {
        "day": "Day 7",
        "topics": [
            "Basics of Connecting Applications",
            "Practical Examples and Hands-on",
            "Troubleshooting Common Issues"
        ]
    },
    {
        "day": "Day 8",
        "topics": [
            "What is Schema Management?",
            "Setting up and Using OpenShift Service Registry",
            "Best Practices in Schema Evolution"
        ]
    },
    {
        "day": "Day 9",
        "topics": [
            "Advanced Use Cases and Integration Patterns",
            "Hands-on Workshop: Implementing Schema Management"
        ]
    },
    {
        "day": "Day 10",
        "topics": [
            "Recap of Key Concepts Covered",
            "Group Project: Implementing a Complete Kafka Solution on OpenShift"
        ]
    }
]

def sanitize_filename(name):
    # Replace any non-alphanumeric character with an underscore and convert to lowercase
    return re.sub(r'[^A-Za-z0-9_]', '_', name).lower()

# Create folders and files
for day in agenda:
    day_folder = sanitize_filename(day["day"].replace(" ", ""))
    os.makedirs(day_folder, exist_ok=True)
    for i, topic in enumerate(day["topics"], start=1):
        filename = f"{i:03d}_" + sanitize_filename(topic.replace(" ", "_")) + ".md"
        filepath = os.path.join(day_folder, filename)
        with open(filepath, 'w') as file:
            file.write(f"# {topic}\n\n")

print("Folders and files created successfully.")
