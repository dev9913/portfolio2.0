//k8s backend policy for argocd notifications

resource "vault_policy" "argocd_notifications" {
  name       = "argocd-notifications"
  depends_on = [helm_release.vault, vault_mount.kvv2]
  policy     = <<EOT
path "secret/data/argocd/notifications" {
  capabilities = ["read"]
}
EOT
}

// k8s backend auth for argocd notifications 
resource "vault_kubernetes_auth_backend_role" "external_secrets" {
  depends_on = [vault_policy.argocd_notifications]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "external-secrets"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_policies                   = [vault_policy.argocd_notifications.name]
  token_ttl                        = 86400
}

// Install External secrets 

resource "helm_release" "external_secrets" {
  depends_on = [vault_kubernetes_auth_backend_role.external_secrets]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
}

// Add Secrets for argocd notifications 

resource "vault_kv_secret_v2" "argocd_notifications" {
  mount = "secret"
  name  = "argocd/notifications"
  depends_on = [vault_mount.kvv2]
  data_json = jsonencode({
    email-username = var.user_email
    email-password = var.user_email_password
  })
}

