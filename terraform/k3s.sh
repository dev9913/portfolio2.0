#!/bin/bash

set -e
echo " Install some tools."

sudo apt install curl zip unzip -y

echo "Installing K3S on this server."
curl -sfL https://get.k3s.io | sh - 

echo " Waiting for K3s to be ready..."
sleep 15

sudo systemctl enable k3s
sudo systemctl start k3s

mkdir -p ~/.kube
sudo k3s kubectl config view --raw > ~/.kube/config
chmod 600 ~/.kube/config

echo "Successfull Install  K3S on this server."

echo "CONFIGURE DNS"
#sudo ls -l /etc/resolve.conf

echo "Create a clean resolve.conf for k3s ."

sudo mkdir -p /etc/rancher/k3s
sudo echo "nameserver 8.8.8.8" >>  /etc/rancher/k3s/resolve.conf
sudo echo "nameserver 1.1.1.1" >>  /etc/rancher/k3s/resolve.conf

echo "File Created Successfully"

echo "Tell K3S to use it ."
sudo echo "resolve-conf: /etc/rancher/k3s/resolv.conf" >> /etc/rancher/k3s/config.yaml

echo "Success !!"

echo "Restart k3s Service !!"
sudo systemctl restart k3s

echo " Waiting for K3s to be ready..."
sleep 60s



