provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "vault" {
  address = "http://vault.vault.svc.cluster.local:8200"
  token   = var.vault_bootstrap_token
}



