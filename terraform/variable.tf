variable "project_Namespace"{
  default = "portfolio"
  type = string
}

variable "vault_bootstrap_token" {
  type      = string
  sensitive = true
}

variable "app_password" {
  type      = string
  sensitive = true
}

variable "db_root_password" {
  type      = string
  sensitive = true
}

