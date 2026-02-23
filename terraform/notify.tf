resource "kubernetes_config_map_v1" "argocd_notifications_cm" {
  depends_on = [helm_release.argocd, kubernetes_secret_v1.argocd_notifications_secret ]
  metadata {
    name      = "argocd-notifications-cm"
    namespace = "argocd"
  }

  data = {
    "context" = <<EOT
argocdUrl: "http://<your-argocd-url>:8080"
EOT

    "service.email" = <<EOT
host: smtp.gmail.com
port: 587
username: $email-username
password: $email-password
from: $email-username
EOT

    "subscriptions" = <<EOT
- recipients:
    - email: yourgmail@gmail.com
  triggers:
    - on-deployed
    - on-health-degraded
    - on-outofsync
EOT

    "template.email-deployed" = <<EOT
email:
  subject: "App {{.app.metadata.name}} deployed ✅"
message: |
  Application {{.app.metadata.name}} in namespace {{.app.metadata.namespace}} was deployed successfully.
EOT

    "template.email-health-degraded" = <<EOT
email:
  subject: "App {{.app.metadata.name}} health degraded ⚠️"
message: |
  Application {{.app.metadata.name}} health is degraded!
  Sync status: {{.app.status.sync.status}}
  Health status: {{.app.status.health.status}}
EOT

    "template.email-outofsync" = <<EOT
email:
  subject: "App {{.app.metadata.name}} is OUT OF SYNC ⚠️"
message: |
  Application {{.app.metadata.name}} is out of sync!
  Sync status: {{.app.status.sync.status}}
  Health status: {{.app.status.health.status}}
EOT

    "trigger.on-deployed" = <<EOT
- when: app.status.operationState.phase == 'Succeeded' and app.status.health.status == 'Healthy'
  send: [email-deployed]
EOT

    "trigger.on-health-degraded" = <<EOT
- when: app.status.health.status == 'Degraded'
  send: [email-health-degraded]
EOT

    "trigger.on-outofsync" = <<EOT
- when: app.status.sync.status == 'OutOfSync'
  send: [email-outofsync]
EOT
  }

}
