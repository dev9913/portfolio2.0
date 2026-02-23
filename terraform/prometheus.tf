// Create Monitoring Namespace
resource "kubernetes_namespace_v1" "monitoring_ns" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus-stack" {

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "55.5.0"  
  namespace  = "monitoring"


  depends_on = [ helm_release.argocd ]
  
  values = [
    file("${path.module}/values/prometheus-value.yaml")
  ]
  
  wait = true
  timeout = 600
}

// Deploy Argocd Monitoring SVC
resource "kubectl_manifest" "argocd_monitoring_svc" {
  yaml_body = file("${path.module}./argocd/argocd-services.yaml")
  depends_on = [helm_release.kube-prometheus-stack, helm_release.argocd]
}

// Deploy Argocd Service Monitoring 
resource "kubectl_manifest" "argocd_monitoring_Service" {
  yaml_body = file("${path.module}./argocd/argocd-servicemonitors.yaml")
  depends_on = [kubectl_manifest.argocd_monitoring_svc]
}

# // Deploy Argocd Monitoring Alert
# resource "kubectl_manifest" "argocd_monitoring_alert_rule" {
#   yaml_body = file("${path.module}./argocd/argocd-alertrules.yaml")
#   depends_on = [kubectl_manifest.argocd_monitoring_Service]
# }

