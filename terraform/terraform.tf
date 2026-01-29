terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.9.0"
    }
 }

}


