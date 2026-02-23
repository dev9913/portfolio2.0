resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd_ns.metadata[0].name

  create_namespace = false

  values = [
    file("${path.module}/values/argo-value.yaml")
  ]

  depends_on = [
    helm_release.kube_prometheus_stack
  ]

  wait    = true
  timeout = 600
}



// Deploy Argocd Notify
resource "kubectl_manifest" "argocd_notify" {
  yaml_body = file("${path.module}./argocd/notify.yaml")
  depends_on = [helm_release.argocd ,kubernetes_secret_v1.argocd_notifications ]
}

// Deploy Argocd Project 
resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./argocd/project.yaml")
  depends_on = [kubectl_manifest.argocd_notify]
}

// Deploy Argocd Application
resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./argocd/application.yaml")

  depends_on = [kubectl_manifest.argocd_project , kubernetes_secret_v1.argocd_app_secret]
}

