resource "kubernetes_manifest" "argocd_server_sm" {
   depends_on = [helm_release.monitoring , kubectl_manifest.argocd_application]
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-server-metrics"
      namespace = "argocd"
      labels = { release = "kube-prometheus-stack" }
    }
    spec = {
      selector = { matchLabels = { "app.kubernetes.io/name" = "argocd-server" } }
      endpoints = [{ port = "metrics" }]
    }
  }
}

resource "kubernetes_manifest" "argocd_repo_sm" {
   depends_on = [helm_release.monitoring , kubectl_manifest.argocd_application]
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-repo-server-metrics"
      namespace = "argocd"
      labels    = { release = "kube-prometheus-stack" }
    }
    spec = {
      selector  = { matchLabels = { "app.kubernetes.io/name" = "argocd-repo-server" } }
      endpoints = [{ port = "metrics" }]
    }
  }
}

resource "kubernetes_manifest" "argocd_controller_sm" {
   depends_on = [helm_release.monitoring , kubectl_manifest.argocd_application]
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "argocd-application-controller-metrics"
      namespace = "argocd"
      labels    = { release = "kube-prometheus-stack" }
    }
    spec = {
      selector  = { matchLabels = { "app.kubernetes.io/name" = "argocd-application-controller" } }
      endpoints = [{ port = "metrics" }]
    }
  }
}
