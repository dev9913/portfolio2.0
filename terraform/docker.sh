#!/bin/bash

set -e
echo "Updating system..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install -y docker.io

echo "Enabling & starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Setting Docker permissions..."
if ! getent group docker >/dev/null; then
  sudo groupadd docker
fi

sudo usermod -aG docker $USER

echo "Restarting Docker..."
sudo systemctl restart docker

echo "Docker installed successfully!"


