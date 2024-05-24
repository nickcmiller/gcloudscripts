#!/bin/bash

# This script creates a Google Cloud Compute instance with a specified name and zone.
# If no name and zone are provided as arguments, it uses default values.
INSTANCE_NAME=${1:-"instance-1"}
ZONE=${2:-"us-west1-b"}

# Retrieve the project ID from the gcloud config and use it if not provided as an argument
RETRIEVED_PROJECT_ID=$(gcloud config get-value project)
PROJECT_ID=${3:-$RETRIEVED_PROJECT_ID}

./create-instance.ssh $INSTANCE_NAME $ZONE $PROJECT_ID
./ssh-instance.sh $INSTANCE_NAME $ZONE $PROJECT_ID

