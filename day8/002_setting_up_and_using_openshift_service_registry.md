# Setting up and Using OpenShift Service Registry

### Prerequisites
1. An OpenShift cluster.
2. OpenShift CLI (`oc`) installed and configured.
3. Admin access to the OpenShift cluster.

### Step-by-Step Guide

#### 1. Create a New Project
First, create a new project (namespace) for the Service Registry.
```sh
oc new-project service-registry
```

#### 2. Install the Service Registry Operator
The Service Registry Operator automates the deployment and management of the Service Registry instance.

1. **Open the OpenShift Web Console.**
2. **Navigate to Operators > OperatorHub.**
3. **Search for "Service Registry" and click on it.**
4. **Click Install and follow the installation wizard.** Ensure you install it to the `service-registry` namespace.

#### 3. Create a Service Registry Instance
Once the operator is installed, create a Service Registry instance.

1. **In the OpenShift Web Console, navigate to Operators > Installed Operators.**
2. **Select the Service Registry Operator from the list.**
3. **Click on the Service Registry tab and then click Create ServiceRegistry.**
4. **Fill in the required details and click Create.**

You can also create the Service Registry instance using a YAML file. Here’s an example:

```yaml
apiVersion: registry.redhat.com/v1alpha1
kind: ServiceRegistry
metadata:
  name: my-service-registry
  namespace: service-registry
spec:
  deployment:
    replicas: 1
```

Apply this YAML file using the `oc` command:
```sh
oc apply -f service-registry.yaml
```

#### 4. Expose the Service Registry
To access the Service Registry from outside the cluster, you need to create a Route.

```sh
oc expose svc/my-service-registry
```

Retrieve the route URL to access the Service Registry:
```sh
oc get route my-service-registry
```

#### 5. Access the Service Registry
Open the URL provided by the route in your web browser to access the Service Registry user interface.

#### 6. Configure the Service Registry
You can configure the Service Registry by editing the instance configuration.

```sh
oc edit serviceregistry my-service-registry
```

### Example Usage
Once the Service Registry is up and running, you can start adding schemas, definitions, and other API artifacts through the user interface or the API.

### Additional Configurations
- **Authentication:** Configure authentication to secure the Service Registry.
- **Scaling:** Adjust the `replicas` in the YAML file to scale the Service Registry.
- **Monitoring:** Set up monitoring for the Service Registry using OpenShift's monitoring tools.

