#!/bin/bash

# Update the package repository
sudo apt-get update

# Install required packages for Docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the key with the fingerprint
sudo apt-key fingerprint 0EBFCD88

# Add the Docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the package repository with Docker packages
sudo apt-get update

# Install Docker CE (Community Edition)
sudo apt-get install docker-ce -y

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Add the current user to the Docker group (to run Docker without sudo)
sudo usermod -aG docker $USER

# Output Docker version to verify installation
docker version
