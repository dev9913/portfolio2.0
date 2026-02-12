resource "kubernetes_namespace_v1" "project_ns" {
  metadata {
    name = var.project_namespace
  }
}

// Vault-install

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

// Argocd install

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




