# ============  Install Hasicorp-Vault ==============


resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = "vault"
  create_namespace = true
  timeout = 600
  wait = true
  atomic            = true
  cleanup_on_fail   = true

  values = [
    file("${path.module}/values-vault.yaml")
  ]
}

// Wait for vault Start

resource "null_resource" "wait_for_vault" {
  depends_on = [helm_release.vault]

  provisioner "local-exec" {
    command = "kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=vault -n vault --timeout=600s"
  }
}

// Start Vault Port_Forward

resource "null_resource" "start_port_forward" {

  depends_on = [null_resource.wait_for_vault]

  
  provisioner "local-exec" {
    command = <<EOT
      kubectl port-forward svc/vault 8200:8200 -n vault > /dev/null 2>&1 &
      echo $! > vault-pf.pid
      sleep 5
    EOT
  }
}

// Stop Vault Port_Forward
resource "null_resource" "stop_port_forward" {

  depends_on = [kubectl_manifest.argocd_monitor]

  provisioner "local-exec" {
    command = <<EOT
      if [ -f vault-pf.pid ]; then
        kill $(cat vault-pf.pid)
        rm vault-pf.pid
      fi
    EOT
  }
}


