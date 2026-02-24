resource "kubernetes_namespace_v1" "argo_rollout_ns" {
  metadata {
    name = "argo-rollouts"
  }
}

resource "helm_release" "argo_rollouts" {
  name       = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  namespace  = kubernetes_namespace_v1.argocd_ns.metadata[0].name

  create_namespace = false

  depends_on = [helm_release.argocd ]

  wait    = true
  timeout = 600
}


