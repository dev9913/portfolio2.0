#!/bin/bash
set -e

echo "=============================="
echo " Updating system packages"
echo "=============================="
sudo apt update -y
sudo apt install -y curl zip unzip ca-certificates



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
sudo newgrp docker

echo "Restarting Docker..."
sudo systemctl restart docker
echo "Docker installed successfully!"





# ======== KUBECTL INSTALLATION ============

echo "=============================="
echo " Installing kubectl"
echo "=============================="

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client
echo " kubectl installed successfully!"
sleep 5

# ======== HELM INSTALLATION ============

echo "=============================="
echo " Installing Helm"
echo "=============================="

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh
rm -f get_helm.sh

helm version
echo " Helm installed successfully!"

# ======== K3S INSTALLATION ============

echo "=============================="
echo " Installing K3s"
echo "=============================="

curl -sfL https://get.k3s.io | sh -

echo " Waiting for K3s to be ready..."
sleep 15

# ======== KUBECONFIG SETUP ============

echo "=============================="
echo " Configuring kubeconfig"
echo "=============================="

mkdir -p $HOME/.kube
sudo k3s kubectl config view --raw > $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config

kubectl get nodes
echo " K3s installed and kubectl configured!"

