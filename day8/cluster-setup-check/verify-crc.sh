#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if CRC is installed
if ! command_exists crc; then
  echo "Error: CRC is not installed."
  exit 1
fi

# Start the CRC cluster
echo "Starting CRC cluster..."
crc start

# Check if CRC started successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to start CRC cluster."
  exit 1
fi

# Check the status of the CRC cluster
CRC_STATUS=$(crc status | grep "OpenShift: .*Running")

if [ -z "$CRC_STATUS" ]; then
  echo "Error: CRC cluster is not running properly."
  exit 1
fi

echo "CRC cluster is running properly."

# Get the OpenShift console URL
CONSOLE_URL=$(crc console --url)

echo "OpenShift Console URL: $CONSOLE_URL"

# Get the API URL from CRC status
API_URL=$(crc status | grep 'API URL' | awk '{print $3}')

# Get the kubeadmin password from the CRC configuration file
KUBEADMIN_PASSWORD=$(crc console --credentials | grep 'kubeadmin' | awk '{print $2}')

echo "API URL: $API_URL"
echo "Kubeadmin Password: $KUBEADMIN_PASSWORD"

echo "CRC installation and cluster setup have been verified successfully."

exit 0
