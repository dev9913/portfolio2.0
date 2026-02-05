#!/bin/bash
set -e

#====== Destroy K3S =======

echo "Stopping K3s..."
sudo systemctl stop k3s || true

echo "Removing K3S..."
/usr/local/bin/k3s-uninstall.sh

echo "K3S removed successfully"


