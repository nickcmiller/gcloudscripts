#!/bin/bash

# This script creates a Google Cloud Compute instance with a specified name and zone.
# If no name and zone are provided as arguments, it uses default values.
INSTANCE_NAME=${1:-"instance-1"}
ZONE=${2:-"us-west1-b"}

# Retrieve the project ID from the gcloud config and use it if not provided as an argument
RETRIEVED_PROJECT_ID=$(gcloud config get-value project)
PROJECT_ID=${3:-$RETRIEVED_PROJECT_ID}

MACHINE_TYPE=${4:-"n1-standard-2"}

# Create the instance
./create-instance.ssh $INSTANCE_NAME $ZONE $PROJECT_ID $MACHINE_TYPE

# Get the public IP address of the instance
PUBLIC_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --project=$PROJECT_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Wait for SSH service to start
echo "Checking SSH connectivity..."
until nc -zvw3 $PUBLIC_IP 22; do
    echo "Waiting for SSH service to start..."
    sleep 10
done

# SSH into the instance
./ssh-instance.sh $INSTANCE_NAME $ZONE $PROJECT_ID

