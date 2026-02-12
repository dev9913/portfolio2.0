# ========================== Vault Secrets Mount ====================== 

resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv-v2"
  depends_on = [helm_release.vault]
  description = "KV Version 2 secret engine mount"
}

# ========================== Policy ====================== 

//k8s Backend Policy for argocd

resource "vault_policy" "k8s_policy" {
  name       = "k8s-policy"
  depends_on = [helm_release.vault]

  policy = <<EOF
path "secret/data/creds" {
  capabilities = ["read"]
}
EOF
}

//k8s backend policy for argocd notifications

resource "vault_policy" "argocd_notifications" {
  name       = "argocd-notifications"
  depends_on = [helm_release.vault]
  policy     = <<EOT
path "secret/data/argocd/notifications" {
  capabilities = ["read"]
}
EOT
}


# ========================== K8s Backend ====================== 

//k8s backend for argocd

resource "vault_auth_backend" "kubernetes" {
  type       = "kubernetes"
  depends_on = [vault_policy.k8s_policy]
}



# ========================== K8s Backend Role  ====================== 

//k8s Backend Role for argocd

resource "vault_kubernetes_auth_backend_role" "k8s_role" {
  depends_on                       = [vault_policy.k8s_policy]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "k8s-role"
  bound_service_account_names      = ["vault-admin"]
  bound_service_account_namespaces = ["portfolio"]
  token_policies                   = [vault_policy.k8s_policy.name]
  token_ttl                        = 86400
}


// k8s backend auth for argocd notifications 
resource "vault_kubernetes_auth_backend_role" "external_secrets" {
  depends_on                       = [vault_policy.argocd_notifications]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "external-secrets"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_policies                   = [vault_policy.argocd_notifications.name]
  token_ttl                        = 86400
}

# ========================== Add Secrets   ====================== 


// Add secrets for argocd

resource "vault_kv_secret_v2" "app_creds" {
  mount = vault_mount.kvv2.path
  name  = "creds"
  
  depends_on = [vault_mount.kvv2]

  data_json = jsonencode({
    password     = var.app_password
    root_password = var.db_root_password
  })
}

// Add Secrets for argocd notifications 

resource "vault_kv_secret_v2" "argocd_notifications" {
  mount = vault_mount.kvv2.path
  name  = "argocd/notifications"

  depends_on = [vault_mount.kvv2]
  
  data_json = jsonencode({
    email-username = var.user_email
    email-password = var.user_email_password
  })
}

# ========================== Stop  ====================== 
