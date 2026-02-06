resource "vault_policy" "argocd_notifications" {
  name = "argocd-notifications"

  policy = <<EOT
path "secret/data/argocd/notifications" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "external_secrets" {
  backend                          = "kubernetes"
  role_name                        = "external-secrets"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["external-secrets"]
  token_policies                   = [vault_policy.argocd_notifications.name]
  token_ttl                        = 3600
}


resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "external-secrets"

  create_namespace = true
}

resource "kubectl_manifest" "vault_secret_store" {
  depends_on = [ 
  helm_release.external_secrets  
]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault.vault.svc:8200"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "external-secrets"
YAML

  
}

resource "kubectl_manifest" "argocd_notifications_secret" {
  depends_on = [
  helm_release.argocd,
  kubectl_manifest.vault_secret_store
]

  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: argocd-notifications-secret
  namespace: argocd
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: argocd-notifications-secret
    creationPolicy: Owner
  data:
    - secretKey: email-username
      remoteRef:
        key: argocd/notifications
        property: email-username
    - secretKey: email-password
      remoteRef:
        key: argocd/notifications
        property: email-password
YAML

 
}

