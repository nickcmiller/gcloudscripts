#!/bin/bash 

# Load instance configuration from instance_config file
source instance_config

# Set the instance name and zone to the arguments provided
# Set to the loaded default config instance name and zone if no argument is provided
INSTANCE_NAME=${1:-$DEFAULT_INSTANCE_NAME}
ZONE=${2:-$DEFAULT_ZONE}
PROJECT_ID=${3:-$DEFAULT_PROJECT_ID}

# Location of Private Key created during authentication
PRIVATE_KEY_PATH=~/.ssh/google_compute_engine

# Check if the instance is running
INSTANCE_STATUS=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --format='get(status)')

# If instance is not running, tell the user to start the instance first and exit the script
if [ "$INSTANCE_STATUS" != "RUNNING" ]; then
  echo "Instance $INSTANCE_NAME is not running. Please start the instance first."
  exit 1
fi

# Get the public IP address of the instance
PUBLIC_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --project=$PROJECT_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Get the username of the instance
USERNAME=$(gcloud compute ssh $INSTANCE_NAME --zone $ZONE --project=$PROJECT_ID --dry-run | awk -F'[@ ]' '{print $(NF-1)}')

# Ensure .ssh key is added to project metadata by lgging in to the instance and running a command
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --project=$PROJECT_ID --command "echo 'Hello from $INSTANCE_NAME.'"

echo "Public IP: $PUBLIC_IP"
echo "Username: $USERNAME"
echo "Identity file: $PRIVATE_KEY_PATH"

# Append config to .ssh/config
cat << EOF >> ~/.ssh/config


Host $INSTANCE_NAME
    HostName $PUBLIC_IP
    IdentityFile $PRIVATE_KEY_PATH
    User $USERNAME
EOF

# ALTERNATIVE TO CONFIG CREATION: SSH into the instance
# ssh -i $PRIVATE_KEY_PATH $USERNAME@$PUBLIC_IP