// APP Namespace
resource "kubernetes_namespace_v1" "portfolio_ns" {
  metadata {
    name = var.project_namespace
  }
}

// Argocd App Secret
resource "kubernetes_secret_v1" "argocd_app_secret" {
  depends_on = [kubernetes_namespace_v1.portfolio_ns]

  metadata {
    name      = "portfolio-secret"
    namespace = var.project_namespace
  }

  data = {
    DB_PASSWORD         = var.app_password
    DB_USER             = var.app_user
    MYSQL_ROOT_PASSWORD = var.db_root_password
  }

  type = "Opaque"
}

// Argocd Notification Secret
resource "kubernetes_secret_v1" "argocd_notifications" {
  depends_on = [kubernetes_namespace_v1.argocd_ns]

  metadata {
    name      = "argocd-notifications-secret"
    namespace = "argocd"
  }

  string_data = {
    email-username = var.gmail_username
    email-password = var.gmail_app_password
  }

  type = "Opaque"

  lifecycle {
    # Prevent accidental deletion of secret
    prevent_destroy = true
  }
}
