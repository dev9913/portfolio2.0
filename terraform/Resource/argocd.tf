resource "kubernetes_namespace_v1" "project_ns" {
  metadata {
    name = var.project_namespace
  }
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  timeout = 600
  wait    = true

  depends_on = [
    helm_release.vault
  ]

  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}

resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./../k8s/argocd/project.yaml")
  depends_on = [
    helm_release.argocd,
  ]
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./../k8s/argocd/application.yaml")

  depends_on = [
    helm_release.argocd,
    kubectl_manifest.argocd_project,

  ]
}

