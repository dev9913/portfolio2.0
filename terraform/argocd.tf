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
    null_resource.stop_port_forward
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
  depends_on = [helm_release.argocd]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
}


