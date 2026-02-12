variable "project_namespace" {
  default = "portfolio"
  type    = string
}

variable "app_password" {
  type      = string
  sensitive = true
}

variable "db_root_password" {
  type      = string
  sensitive = true
}

variable "vault_bootstrap_token" {
  type      = string
  sensitive = true
}


variable "user_email" {
  type      = string
  sensitive = true
}

variable "user_email_password" {
  type      = string
  sensitive = true
}

