#!/bin/bash
set -e

echo " Updating system packages"
sudo apt update -y
sudo apt install -y curl zip unzip ca-certificates


# ======== KUBECTL INSTALLATION ============

echo " Installing kubectl"

curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo " kubectl installed successfully!"
sleep 5

# ======== HELM INSTALLATION ============

echo " Installing Helm"

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
sudo ./get_helm.sh
rm -f get_helm.sh

echo " Helm installed successfully!"

# ======== K3S INSTALLATION ============

echo " Installing K3s"

curl -sfL https://get.k3s.io | sh -

echo " Waiting for K3s to be ready..."
sleep 15

# ======== KUBECONFIG SETUP ============

echo " Configuring kubeconfig"

mkdir -p $HOME/.kube
sudo k3s kubectl config view --raw > $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
chmod 600 $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
echo " K3s installed and kubectl configured!"

