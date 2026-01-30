variable "project_Namespace"{
  default = "portfolio"
  type = string
}

variable "cluster_name" {
  default = "portfolio"
  type = string
}

variable "node_image" {
  default = "kindest/node:v1.29.2" 
  type = string
}

variable "ingress_controller_name" {
  default = "nginx-controller"
  type = string
}

