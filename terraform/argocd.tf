# ============ Portfolio Namespace ==============
resource "kubernetes_namespace_v1" "project_ns" {
  metadata {
    name = var.project_namespace
  }
}

# ============  Install Hasicorp-Vault ==============


resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = "vault"
  create_namespace = true

  values = [
    file("${path.module}/values-vault.yaml")
  ]

  wait    = true
  timeout = 600
}

# ============ Install Argocd ==============


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  timeout = 600
  wait    = true

  depends_on = [
    helm_release.vault,
    vault_kv_secret_v2.app_creds
  ]

  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}

# ============ Install External secrets  ==============
 
resource "helm_release" "external_secrets" {
  depends_on = [helm_release.vault,helm_release.argocd]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
}


