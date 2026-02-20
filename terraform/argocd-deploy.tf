// Deploy Argocd  Secret-Store

resource "kubectl_manifest" "argocd_secret_store" {
  yaml_body = file("${path.module}./k8s/argocd/secret-store.yaml")
  depends_on = [helm_release.external_secrets]
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

// Deploy Argocd Project 
resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./k8s/argocd/project.yaml")
  depends_on = [helm_release.argocd]
}

// Deploy Argocd Application
resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./k8s/argocd/application.yaml")

  depends_on = [
    kubectl_manifest.argocd_project
  ]
}

// Deploy Argocd Monitor

resource "kubectl_manifest" "argocd_monitor" {
  yaml_body = file("${path.module}./k8s/argocd/monitoring.yaml")

  depends_on = [
    kubectl_manifest.argocd_application
  ]
}



