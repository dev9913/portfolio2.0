#!/bin/bash
set -euo pipefail

### CONFIG ###
S3_BUCKET="my-sealed-secrets-backup"
S3_KEY_PATH="sealed-secrets/sealed-secrets-key.yaml"
NAMESPACE="kube-system"
SECRET_NAME="sealed-secrets-key"
CONTROLLER_DEPLOYMENT="sealed-secrets-controller"

TMP_DIR="/tmp/sealed-secrets-restore"
KEY_FILE="$TMP_DIR/sealed-secrets-key.yaml"

echo " Restoring Sealed Secrets key from S3..."
echo "----------------------------------------"

mkdir -p "$TMP_DIR"

echo " Downloading key from S3..."
aws s3 cp "s3://${S3_BUCKET}/${S3_KEY_PATH}" "$KEY_FILE"

echo " Downloaded key file"

echo " Applying Sealed Secrets key to cluster..."
kubectl apply -f "$KEY_FILE"

echo " Verifying secret exists..."
kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" >/dev/null

echo " Restarting Sealed Secrets controller..."
kubectl rollout restart deployment "$CONTROLLER_DEPLOYMENT" -n "$NAMESPACE"

echo " Waiting for controller to be ready..."
kubectl rollout status deployment "$CONTROLLER_DEPLOYMENT" -n "$NAMESPACE"

echo " Restore completed successfully!"


