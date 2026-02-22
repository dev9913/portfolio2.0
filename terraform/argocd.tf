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
    null_resource.start_port_forward
  ]

  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}



// Deploy Argocd Project 
resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./k8s/argocd/project.yaml")
  depends_on = [helm_release.argocd, kubectl_manifest.argocd_alert_notify]
}

// Deploy Argocd Application
resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./k8s/argocd/application.yaml")

  depends_on = [
    kubectl_manifest.argocd_project
  ]
}

