provider "null" {}

# Install K3s via shell script
resource "null_resource" "install_k3s" {
  provisioner "local-exec" {
    command = "${path.module}/k3s.sh"
  }
 
  # Destroy-time cleanup
  
  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/k3s-destroy.sh"
  }
}

