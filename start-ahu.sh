#!/bin/bash

# Get current user ID and group ID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "Starting AHU container with user $USER_ID:$GROUP_ID"

# Update docker-compose.yml with current user
sed -i.bak "s/user: \"[0-9]*:[0-9]*\"/user: \"$USER_ID:$GROUP_ID\"/" docker-compose.yml

# Start the service
docker-compose up -d ahu

echo "AHU service started successfully!"
