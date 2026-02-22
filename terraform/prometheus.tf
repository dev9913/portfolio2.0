resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  version          = "56.6.2"
  create_namespace = true
  values = [
    file("${path.module}/prom-values.yaml")  
  ]
  timeout = 600
  wait = true
  atomic            = true
  cleanup_on_fail   = true
}

// Deploy Argocd Metrics

resource "kubectl_manifest" "monitoring" {
  yaml_body = file("${path.module}./k8s/argocd/monitoring.yaml")
  depends_on = [helm_release.prometheus,helm_release.argocd]
}

