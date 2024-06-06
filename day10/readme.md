### Installation and Running Kafdrop

#### Prerequisites:
- Java 17
- Kafka

#### Step 1: Install Java 17 on Red Hat Enterprise Linux

1. **Install Java 17 via Alternatives**

   ```bash
   sudo yum update
   sudo yum install java-17-openjdk-devel
   sudo alternatives --config java
   ```

   Select Java 17 from the list of installed Java versions.

2. **Verify Installation**

   ```bash
   java -version
   ```

#### Step 2: Download Kafdrop

1. **Download the JAR file**

   ```bash
   wget https://github.com/obsidiandynamics/kafdrop/releases/download/3.29.0/kafdrop-3.29.0.jar -O kafdrop.jar
   ```

#### Step 3: Run Kafdrop

1. **Run Kafdrop with Command Line Options**

   ```bash
   java -jar kafdrop.jar --kafka.brokerConnect=<broker-list> --server.port=9000
   ```

   Replace `<broker-list>` with your Kafka broker addresses, e.g., `localhost:9092`.

-------------------------------------------------------

