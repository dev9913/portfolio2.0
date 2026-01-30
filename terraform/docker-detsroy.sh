#!/bin/bash
set -e

echo "Stopping Docker..."
sudo systemctl stop docker || true

echo "Removing Docker..."
sudo apt purge -y docker.io docker-ce docker-ce-cli containerd runc || true
sudo apt autoremove -y
rm -rf /var/lib/docker
rm -rf /etc/docker

echo "Docker removed successfully"

