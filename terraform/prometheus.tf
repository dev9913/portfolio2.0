// Create ArgoCd Namespace
resource "kubernetes_namespace_v1" "monitoring_ns" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "monitoring" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"


  depends_on = [ helm_release.argocd ]
  version = "56.6.2"

  timeout = 600
  wait = true
  atomic            = true
  cleanup_on_fail   = true

  values = [
    file("${path.module}/prom-values.yaml")
  ]
}

