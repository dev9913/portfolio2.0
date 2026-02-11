resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.6.2"
  namespace        = "monitoring"
  create_namespace = true

  depends_on = [helm_release.argocd]
  set = [
    {
      name  = "prometheus.service.type"
      value = "ClusterIP"
    },
    {
      name  = "grafana.service.type"
      value = "ClusterIP"
    },
    {
      name  = "alertmanager.service.type"
      value = "ClusterIP"
    },
    {
      name  = "kubeEtcd.enabled"
      value = "false"
    },
    {
      name  = "kubeControllerManager.enabled"
      value = "false"
    }

  ]
  timeout = 300
  wait    = true

}

resource "kubectl_manifest" "argocd_monitor" {
  yaml_body = file("${path.module}./../k8s/argocd/monitoring.yaml")

  depends_on = [
    helm_release.argocd,
    helm_release.prometheus,
    kubectl_manifest.argocd_project,
    kubectl_manifest.argocd_application
  ]
}
