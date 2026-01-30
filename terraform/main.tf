resource "null_resource" "docker"{
  triggers = {
    script_hash = filemd5("docker.sh")
  }
  # install Docker
  provisioner "local-exec"{
    command = "bash docker.sh"
  }
  
  # Uninstall Docker on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "bash docker-detsroy.sh"
  }
}


resource "kind_cluster" "cluster" {
  name           = var.cluster_name
  node_image     = var.node_image
  wait_for_ready = true
  kubeconfig_path = pathexpand("/tmp/config")
  depends_on = [ null_resource.docker ]
 
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
          container_port = 80
          host_port = 80 
      }
    }

    node {
      role = "worker"
    }
  }
}

