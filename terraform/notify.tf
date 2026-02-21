# ============ Install External secrets  ==============
 
resource "helm_release" "external_secrets" {

  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
  wait             = true
  timeout          = 300
}

resource "null_resource" "wait_for_external_secrets_crds" {
  depends_on = [helm_release.external_secrets]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for External Secrets CRDs..."
      until kubectl get crd clustersecretstores.external-secrets.io >/dev/null 2>&1; do
        sleep 3
      done
      echo "CRDs ready."
    EOT
  }
}

// Deploy Argocd  Secret-Store

resource "kubectl_manifest" "argocd_secret_store" {
  yaml_body = file("${path.module}./k8s/argocd/secret-store.yaml")
  depends_on = [null_resource.wait_for_external_secrets_crds , helm_release.argocd]
}

// Deploy Argocd External Secrets

resource "kubectl_manifest" "argocd_externalsecrets" {
  yaml_body  = file("${path.module}./k8s/argocd/externalsecret.yaml")
  depends_on = [kubectl_manifest.argocd_secret_store]
}


// Deploy Argocd  Notifications

resource "kubectl_manifest" "argocd_notification" {
  yaml_body = file("${path.module}./k8s/argocd/notification.yaml")
  depends_on = [kubectl_manifest.argocd_externalsecrets]
   
}
