resource "kubernetes_namespace_v1" "argocd_ns"{
  metadata {
    name = var.argocd_Namespace
 }
}


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace = var.argocd_Namespace 
  create_namespace = true
  timeout = 600
  wait = true
  
  depends_on = [
    null_resource.install_k3s
  ]
  
  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}


resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./k8s/argocd/project.yaml")
  depends_on = [
    helm_release.argocd
  ]
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./k8s/argocd/application.yaml")

  depends_on = [
    helm_release.argocd,
    kubectl_manifest.argocd_project
  ]
}

