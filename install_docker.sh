#!/bin/bash

# Update the package database
echo "Updating package database..."
sudo apt-get update

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y docker.io

# Start and enable Docker
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker is installed correctly
echo "Checking Docker version..."
docker --version

# Provide feedback on whether Docker was installed successfully
if [ $? -eq 0 ]; then
    echo "Docker was installed successfully!"
else
    echo "Docker installation failed."
fi
