# Key Features of OpenShift Application Services

## OpenShift Command Line Interface (CLI)

The OpenShift CLI (`oc`) is a powerful tool that allows developers and administrators to interact with an OpenShift cluster from the command line. It provides a wide range of commands for managing projects, applications, and the cluster itself.

### Setting Up `oc`

#### Prerequisites

- **OpenShift Cluster**: Ensure you have access to an OpenShift cluster.
- **CLI Installation**: Install the OpenShift CLI on your local machine.

#### Installation Steps

1. **Download the `oc` CLI**
   - Download the appropriate version of the `oc` CLI for your operating system from the Redhat Website.

2. **Install the `oc` CLI**
   - Extract the downloaded archive and move the `oc` binary to a directory in your PATH.

3. **Log In to OpenShift**
   - Log in to the OpenShift cluster:
     ```bash
     $ oc login https://<api-url>:6443 --username=<username> --password=<password>
     ```

### OpenShift CLI (`oc`) Commands and Use Cases

#### 1. General Commands

- **oc login**
  - **Description**: Logs in to the OpenShift cluster.
  - **Use Case**: Use this command to authenticate with your OpenShift cluster.
  - **Example**:
    ```bash
    $ oc login https://api.crc.testing:6443 --username=developer --password=developer
    ```

- **oc logout**
  - **Description**: Logs out of the OpenShift cluster.
  - **Use Case**: Use this command to end your session.
  - **Example**:
    ```bash
    $ oc logout
    ```

- **oc status**
  - **Description**: Shows an overview of the current project.
  - **Use Case**: Use this command to get a summary of the project status.
  - **Example**:
    ```bash
    $ oc status
    ```

- **oc version**
  - **Description**: Displays the client and server version information.
  - **Use Case**: Use this command to verify the version of OpenShift CLI and the cluster.
  - **Example**:
    ```bash
    $ oc version
    ```

#### 2. Project Management

- **oc new-project**
  - **Description**: Creates a new project.
  - **Use Case**: Use this command to create a new project/namespace.
  - **Example**:
    ```bash
    $ oc new-project myproject --display-name="My Project" --description="This is my project"
    ```

- **oc project**
  - **Description**: Switches to a different project.
  - **Use Case**: Use this command to switch between different projects.
  - **Example**:
    ```bash
    $ oc project myproject
    ```

- **oc get projects**
  - **Description**: Lists all projects.
  - **Use Case**: Use this command to see all available projects.
  - **Example**:
    ```bash
    $ oc get projects
    ```

- **oc delete project**
  - **Description**: Deletes a project.
  - **Use Case**: Use this command to remove a project and its resources.
  - **Example**:
    ```bash
    $ oc delete project myproject
    ```

#### 3. Application Management

- **oc new-app**
  - **Description**: Creates a new application from source code, templates, or images.
  - **Use Case**: Use this command to deploy new applications.
  - **Example**:
    ```bash
    $ oc new-app https://URLOFREPOSITORY --name=myapp
    ```

- **oc expose**
  - **Description**: Exposes a service, deployment, or pod as a route.
  - **Use Case**: Use this command to create a route to your application.
  - **Example**:
    ```bash
    $ oc expose svc/myapp
    ```

- **oc get**
  - **Description**: Retrieves information about API objects.
  - **Use Case**: Use this command to list resources such as pods, services, and deployments.
  - **Example**:
    ```bash
    $ oc get pods
    $ oc get svc
    ```

- **oc describe**
  - **Description**: Shows details about a specific resource.
  - **Use Case**: Use this command to get detailed information about resources.
  - **Example**:
    ```bash
    $ oc describe pod <pod-name>
    ```

- **oc logs**
  - **Description**: Retrieves logs for a specific pod or container.
  - **Use Case**: Use this command to view application logs.
  - **Example**:
    ```bash
    $ oc logs <pod-name>
    ```

- **oc delete**
  - **Description**: Deletes a resource.
  - **Use Case**: Use this command to remove resources.
  - **Example**:
    ```bash
    $ oc delete pod <pod-name>
    ```

#### 4. Configuration and Deployment

- **oc set**
  - **Description**: Updates objects on the server.
  - **Use Case**: Use this command to change image, env variables, or other settings.
  - **Example**:
    ```bash
    $ oc set image dc/myapp myapp=image:v2
    ```

- **oc rollout**
  - **Description**: Manages the rollout of deployments.
  - **Use Case**: Use this command to start, pause, or resume a rollout.
  - **Example**:
    ```bash
    $ oc rollout status dc/myapp
    ```

- **oc scale**
  - **Description**: Scales the number of replicas for a deployment.
  - **Use Case**: Use this command to increase or decrease the number of pod replicas.
  - **Example**:
    ```bash
    $ oc scale --replicas=3 dc/myapp
    ```

- **oc create**
  - **Description**: Creates a resource from a file or from stdin.
  - **Use Case**: Use this command to create resources defined in YAML or JSON files.
  - **Example**:
    ```bash
    $ oc create -f myapp.yaml
    ```

#### 5. Security and Access Control

- **oc adm policy**
  - **Description**: Manages policies for users, groups, and roles.
  - **Use Case**: Use this command to assign roles and manage access control.
  - **Example**:
    ```bash
    $ oc adm policy add-role-to-user edit <username> -n <project>
    ```

- **oc policy**
  - **Description**: Manages authorization policies.
  - **Use Case**: Use this command to view and modify access control policies.
  - **Example**:
    ```bash
    $ oc policy can-i <verb> <resource> -n <project>
    ```

#### 6. Troubleshooting

- **oc exec**
  - **Description**: Executes a command in a container.
  - **Use Case**: Use this command to run commands inside a running pod.
  - **Example**:
    ```bash
    $ oc exec <pod-name> -- <command>
    ```

- **oc rsync**
  - **Description**: Synchronizes files between a local directory and a pod directory.
  - **Use Case**: Use this command to copy files to and from containers.
  - **Example**:
    ```bash
    $ oc rsync <local-dir> <pod-name>:/<remote-dir>
    ```

- **oc debug**
  - **Description**: Creates debugging sessions for nodes, pods, or other resources.
  - **Use Case**: Use this command to troubleshoot and diagnose issues.
  - **Example**:
    ```bash
    $ oc debug node/<node-name>
    ```

### Use Cases for `oc` Commands

1. **Managing Projects and Applications**
   - Use `oc new-project`, `oc project`, and `oc delete project` to create, switch, and manage projects.
   - Use `oc new-app`, `oc expose`, and `oc delete` to deploy and manage applications.

2. **Scaling and Updating Applications**
   - Use `oc scale` and `oc set` to adjust the scale and configuration of your deployments.
   - Use `oc rollout` to manage application rollouts and deployments.

3. **Access Control and Security**
   - Use `oc adm policy` and `oc policy` to manage user permissions and access control within your projects.

4. **Monitoring and Debugging**
   - Use `oc get`, `oc describe`, and `oc logs` to monitor the state of your resources.
   - Use `oc exec`, `oc rsync`, and `oc debug` for troubleshooting and debugging.

