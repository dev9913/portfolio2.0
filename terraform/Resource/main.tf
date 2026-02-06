resource "null_resource" "k3s" {
  triggers = {
    install_hash = filemd5("${path.module}./scripts/k3s.sh")
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "bash ${path.module}./scripts/k3s.sh"
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "bash ${path.module}./scripts/k3s-destroy.sh"
  }
}

