// Create ArgoCd Namespace
resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata {
    name = "argocd"
  }
}


// Install Argo-CD

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"

  timeout = 600
  wait    = true
  atomic            = true
  cleanup_on_fail   = true

  depends_on = [ kubernetes_namespace_v1.argocd_ns , kubernetes_secret_v1.argocd_app_secret]
  values = [
    file("${path.module}/argo-value.yaml")
  ]
}

// Deploy Argocd Notifications 
resource "kubectl_manifest" "argocd_notify" {
  yaml_body = file("${path.module}./argocd/notify.yaml")
  depends_on = [kubernetes_secret_v1.argocd_notifications_secret]
}

// Deploy Argocd Project 
resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./argocd/project.yaml")
  depends_on = [kubectl_manifest.argocd_notify]
}

// Deploy Argocd Application
resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./argocd/application.yaml")

  depends_on = [kubectl_manifest.argocd_project]
}

