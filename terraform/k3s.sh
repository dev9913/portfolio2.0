#!/bin/bash

set -e

# ======== DOCKER INSTALLATION ============


echo "Updating system..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install -y docker.io

echo "Enabling & starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Setting Docker permissions..."

sudo usermod -aG docker $USER
newgrp docker

echo "Restarting Docker..."
sudo systemctl restart docker

echo "Docker installed successfully!"


# ======== KUBECTL  INSTALLATION ============

echo " Installing kubectl "
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"   

echo "Enable Kubectl..."
chmod +x ./kubectl   
sudo mv ./kubectl /usr/local/bin/kubectl   

echo " Successfull Install Kubectl !!"
sleep 15s

# ======== Helm  INSTALLATION ============

echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4

echo "Configure Helm..."
chmod 700 get_helm.sh
./get_helm.sh
echo " Helm installed successfully!"


# ======== K3S INSTALLATION ============


echo " Installing required tools..."
sudo apt update
sudo apt install -y curl zip unzip

echo " Installing K3s..."
curl -sfL https://get.k3s.io | sh -

echo " Waiting for K3s to be ready..."
sleep 15

echo " Configuring kubeconfig..."
mkdir -p $HOME/.kube
sudo k3s kubectl config view --raw > $HOME/.kube/config
chmod 600 $HOME/.kube/config

echo " K3s installed successfully!"


# ======== KUBESEAL INSTALLATION ============

echo " Installing Kubeseal..."
wget https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/kubeseal-linux-amd64
echo " Configuring kubeseal..."
sudo install -m 755 kubeseal-linux-amd64 /usr/local/bin/kubeseal
echo " Kubeseal installed successfully!"



