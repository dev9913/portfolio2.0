#!/bin/bash
set -e

export VAULT_ADDR="http://vault.vault.svc.cluster.local:8200"

echo "Using VAULT_TOKEN for authentication"
vault status

echo "Write app/database secrets"
vault kv put secret/creds \
  user=portfolio \
  password="$APP_PASSWORD" \
  root_password="$DB_ROOT_PASSWORD"

echo "Write ArgoCD notification secrets"
vault kv put secret/argocd/notifications \
  email-username="$USER_EMAIL" \
  email-password="$USER_EMAIL_PASSWORD"

echo "Done"

