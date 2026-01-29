resource "helm_release" "nginx_ingress" {
  name       = var.ingress_controller_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  namespace        = var.project_Namespace
  create_namespace = true
  depends_on = [
    kind_cluster.cluster,
    helm_release.argocd,
    kubernetes_namespace_v1.project_ns
    
  ]
  
  timeout = 300
  wait    = true

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "ingressClass"
    value = "nginx"
  }

  set {
    name  = "ingressClassResource.name"
    value = "nginx"
  }

  set {
    name  = "ingressClassResource.default"
    value = "true"
  }
}

