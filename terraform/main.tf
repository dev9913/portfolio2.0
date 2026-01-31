resource "null_resource" "k3s"{
  triggers = {
    script_hash = filemd5("k3s.sh")
  }
  # install Docker
  provisioner "local-exec"{
    command = "bash k3s.sh"
  }
  
  # Uninstall Docker on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "bash k3s-destroy.sh"
  }
}

resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"

  create_namespace = false

  values = [<<EOF
fullnameOverride: sealed-secrets-controller
keyRenewPeriod: "0"
generateKey: false
EOF
  ]
}


