resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  namespace        = "vault"
  create_namespace = true

  set = [{
    name  = "server.dev.enabled"
    value = "true"
    },

    {
      name  = "server.ha.enabled"
      value = "false"
    },

    {
      name  = "server.dataStorage.enabled"
      value = "true"
  }]

}



