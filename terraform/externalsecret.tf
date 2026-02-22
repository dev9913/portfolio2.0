resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.10.1"
  namespace        = "external-secrets"
  create_namespace = true
  timeout           = 600
  wait              = true
  
}


// Deploy Argocd  Alert

resource "kubectl_manifest" "argocd_alert_secret_store" {
  yaml_body = file("${path.module}./k8s/argocd/secret-store.yaml")
  depends_on = [helm_release.external_secrets,helm_release.argocd]
}


resource "kubectl_manifest" "argocd_alert_extrenal_secret" {
  yaml_body = file("${path.module}./k8s/argocd/external-secret.yaml")
  depends_on = [kubectl_manifest.argocd_alert_secret_store]
}


resource "kubectl_manifest" "argocd_alert_notify" {
  yaml_body = file("${path.module}./k8s/argocd/notify.yaml")
  depends_on = [kubectl_manifest.argocd_alert_extrenal_secret]
}
