resource "kubernetes_namespace_v1" "monitoring_ns" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace_v1.monitoring_ns.metadata[0].name

  create_namespace = false

  values = [
    file("${path.module}/values/prometheus-value.yaml")
  ]

  wait    = true
  timeout = 600
}

// Deploy Argocd Service
resource "kubectl_manifest" "argocd_svc" {
  yaml_body = file("${path.module}./argocd/service-monitoring.yaml")
 depends_on = [helm_release.argocd]
}

