#!/bin/bash
set -e

: "${APP_PASSWORD:?missing}"
: "${DB_ROOT_PASSWORD:?missing}"

export VAULT_ADDR="http://vault.vault.svc.cluster.local:8200"

echo "Login via Kubernetes auth"
vault login -method=kubernetes role=k8s-role


echo "Write secrets"
vault kv put secret/creds \
  user=portfolio \
  password="$APP_PASSWORD" \
  root_password="$DB_ROOT_PASSWORD"

echo "Done"

