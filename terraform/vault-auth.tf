# ============ Portfolio Namespace ==============

resource "kubernetes_namespace_v1" "portfolio" {
  metadata {
    name = var.project_namespace
  }
}

# ========================== Add Secrets   ====================== 


// Add secrets for argocd

resource "vault_kv_secret_v2" "app_creds" {
  mount = "secret"
  name  = "creds"
  
  depends_on = [null_resource.start_port_forward]

  data_json = jsonencode({
    password      = var.app_password
    user          = var.app_user
    root_password = var.db_root_password
  })
}



# ========================== Policy ====================== 

//k8s Backend Policy for argocd

resource "vault_policy" "k8s_policy" {
  name       = "k8s-policy"
  depends_on = [vault_kv_secret_v2.app_creds]

  policy = <<EOF
path "secret/data/creds" {
  capabilities = ["read"]
}
EOF
}



# ========================== K8s Backend ====================== 

resource "vault_auth_backend" "kubernetes" {
  depends_on = [null_resource.start_port_forward]
  type = "kubernetes"
}

# ========================== K8s Backend Config  ======================


// service accounts 

resource "kubernetes_service_account_v1" "vault_admin" {
  depends_on = [vault_auth_backend.kubernetes]
  
  metadata {
    name      = "vault-admin"
    namespace = kubernetes_namespace_v1.portfolio.metadata[0].name
  }
}



// Role And RoleBinding

resource "kubernetes_role_v1" "vault_admin_token" {
  depends_on = [kubernetes_service_account_v1.vault_admin]
  
  metadata {
    name      = "vault-admin-token"
    namespace = kubernetes_namespace_v1.portfolio.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["serviceaccounts/token"]
    verbs      = ["create"]
  }
}


resource "kubernetes_role_binding_v1" "vault_admin_token_binding" {
  depends_on = [kubernetes_role_v1.vault_admin_token]
  
  metadata {
    name      = "vault-admin-token-binding"
    namespace = kubernetes_namespace_v1.portfolio.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "vault"
    namespace = "vault"
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role_v1.vault_admin_token.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}


# ========================== K8s Backend Auth  ====================== 


resource "vault_kubernetes_auth_backend_config" "k8s_config" {
  backend = vault_auth_backend.kubernetes.path
  kubernetes_host =   var.kubernetes_host
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


