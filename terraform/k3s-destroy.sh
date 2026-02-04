#!/bin/bash
set -e

#====== Destroy Docker =======

echo "Stopping Docker..."
sudo systemctl stop docker || true

echo "Removing Docker..."
sudo apt purge -y docker.io docker-ce docker-ce-cli containerd runc || true
sudo apt autoremove -y
rm -rf /var/lib/docker
rm -rf /etc/docker

echo "Docker removed successfully"

#====== Destroy Docker =======

echo "Stopping K3s..."
sudo systemctl stop k3s || true

echo "Removing K3S..."
/usr/local/bin/k3s-uninstall.sh

echo "K3S removed successfully"


