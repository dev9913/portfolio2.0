resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  depends_on = [helm_release.vault]
  description = "KV Version 2 secret engine mount"
}

//k8s backend for argocd

resource "vault_auth_backend" "kubernetes" {
  type       = "kubernetes"
  depends_on = [vault_mount.kvv2]
}

//k8s Backend Policy for argocd

resource "vault_policy" "k8s_policy" {
  name       = "k8s-policy"
  depends_on = [vault_auth_backend.kubernetes]

  policy = <<EOF
path "secret/data/creds" {
  capabilities = ["read", "create", "update"]
}
EOF
}

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

// Add secrets for argocd

resource "vault_kv_secret_v2" "app_creds" {
  mount = "secret"
  name  = "creds"
  depends_on = [vault_mount.kvv2]

  data_json = jsonencode({
    password     = var.app_password
    root_password = var.db_root_password
  })
}


