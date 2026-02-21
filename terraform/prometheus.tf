# ============ Install Prometheus  ==============

resource "helm_release" "prometheus" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.6.2"
  namespace        = "monitoring"
  create_namespace = true

  values = [file("${path.module}/monitoring-values.yaml")]

  timeout = 600
  wait    = true
}

// Deploy Argocd Monitor

resource "kubectl_manifest" "argocd_monitor" {
  yaml_body = file("${path.module}./k8s/argocd/monitoring.yaml")

  depends_on = [
    helm_release.prometheus , kubectl_manifest.argocd_application
  ]
}
