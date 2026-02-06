resource "vault_auth_backend" "kubernetes" {
  type       = "kubernetes"
  depends_on = [helm_release.vault]
}

resource "vault_policy" "k8s_policy" {
  name       = "k8s-policy"
  depends_on = [vault_auth_backend.kubernetes]

  policy = <<EOF
path "secret/data/creds" {
  capabilities = ["read", "create", "update"]
}
EOF
}

resource "vault_kubernetes_auth_backend_role" "k8s_role" {
  depends_on = [
    vault_auth_backend.kubernetes,
    vault_policy.k8s_policy
  ]
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "k8s-role"
  bound_service_account_names      = ["vault-admin"]
  bound_service_account_namespaces = ["portfolio"]
  token_policies                   = [vault_policy.k8s_policy.name]
  token_ttl                        = 86400
}



resource "null_resource" "vault_setup" {
  depends_on = [
    helm_release.vault,
    vault_auth_backend.kubernetes,
    vault_policy.k8s_policy,
    vault_kubernetes_auth_backend_role.k8s_role

  ]
  provisioner "local-exec" {
    environment = {
      APP_PASSWORD        = var.app_password
      DB_ROOT_PASSWORD    = var.db_root_password
      VAULT_BOOTSTRAP_TOKEN = var.vault_bootstrap_token
      USER_EMAIL          = var.user_email
      USER_EMAIL_PASSWORD = var.user_email_password
    }

    interpreter = ["/bin/bash", "-c"]
    command     = "bash ${path.module}./scripts/vault.sh"
  }
}
