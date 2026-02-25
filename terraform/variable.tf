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

variable "app_user" {
  default = "portfolio"
  type =  string
 }

variable "enable_argocd_metrics" {
  description = "Enable ArgoCD metrics in values"
  type        = bool
  default     = true
}

variable "user_email" {
  description = "Gmail address for sending notifications"
  type        = string
  sensitive   = true
}

variable "user_email_password" {
  description = "Gmail App Password for SMTP authentication"
  type        = string
  sensitive   = true
}

variable "notification_email_recipients" {
  description = "Email addresses to receive notifications"
  type        = list(string)
  default     = []
}
