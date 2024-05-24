#!/bin/bash

# Load instance configuration from instance_config file
source instance_config

# Set the instance name and zone to the arguments provided
# Set to the loaded default config instance name and zone if no argument is provided
INSTANCE_NAME=${1:-$DEFAULT_INSTANCE_NAME}
ZONE=${2:-$DEFAULT_ZONE}
PROJECT_ID=${3:-$DEFAULT_PROJECT_ID}

# Delete the instance
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE --project=$PROJECT_ID

# Delete the SSH config for the instance
sed -i '' "/^Host $INSTANCE_NAME$/,/^$/d" ~/.ssh/config


