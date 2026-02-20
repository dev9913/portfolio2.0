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

