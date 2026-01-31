resource "kubernetes_namespace_v1" "project_ns"{
  metadata {
    name = var.project_Namespace
 }
}


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  =  "argocd" 
  create_namespace = true
  timeout = 600
  wait = true
  
<<<<<<< HEAD
=======
  depends_on = [
     null_resource.k3s
  ]
  
>>>>>>> 1a57c139 (update files)
  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}


resource "null_resource" "secret_restore"{
  triggers = {
    script_hash = filemd5("restore-sealed-secrets-key.sh")
  }
  
  depends_on = [
     null_resource.k3s,
     kubernetes_namespace_v1.project_ns,
     helm_release.argocd
  ]

  # install Docker
  provisioner "local-exec"{
    command = "bash restore-sealed-secrets-key.sh"
  }
  
 
}


resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./k8s/argocd/project.yaml")
  depends_on = [
    helm_release.argocd,
    null_resource.secret_restore
  ]
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./k8s/argocd/application.yaml")

  depends_on = [
    helm_release.argocd,
    kubectl_manifest.argocd_project,
    null_resource.secret_restore
  ]
}

