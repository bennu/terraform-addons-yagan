resource kubernetes_namespace cert_manager {
  count = local.enable_cert_manager ? 1 : 0
  metadata {
    name = "cert-manager"
  }
}

resource helm_release cert_manager {
  count      = local.enable_cert_manager ? 1 : 0
  atomic     = true
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.0.metadata.0.name
  repository = "https://charts.jetstack.io"
  version    = local.cert_manager_version
  values = [
    yamlencode(
      {
        installCRDs  = true
        podDnsPolicy = "None"
        podDnsConfig = {
          nameservers = ["1.1.1.1", "8.8.8.8"]
        }
        extraArgs = ["--dns01-recursive-nameservers-only","--dns01-recursive-nameservers=\"8.8.8.8:53,1.1.1.1:53\""]
      }
    )
  ]
}

resource kubernetes_secret cert_manager_credentials {
  count = local.enable_cert_manager ? 1 : 0
  metadata {
    name      = "cert-manager-credentials"
    namespace = kubernetes_namespace.cert_manager.0.metadata.0.name
  }

  data = {
    secret_key = var.cert_manager_secret_key
  }
}

resource null_resource cluster_issuer {
  depends_on = [helm_release.cert_manager, kubernetes_secret.cert_manager_credentials]
  count      = local.enable_cert_manager ? 1 : 0

  triggers = {
    manifest = templatefile(format("%s/files/cluster-issuer.yml", path.module), local.cert_manager_config)
  }

  provisioner "local-exec" {
    command     = format("echo '%s'|kubectl apply -f -", self.triggers.manifest)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = format("echo '%s'|kubectl delete -f -", self.triggers.manifest)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource null_resource default_cert {
  depends_on = [helm_release.cert_manager, kubernetes_secret.cert_manager_credentials, null_resource.cluster_issuer]
  count      = local.enable_cert_manager ? 1 : 0

  triggers = {
    manifest = yamlencode(
      {
        apiVersion = "cert-manager.io/v1alpha2"
        kind       = "Certificate"
        metadata = {
          name      = "default-cert"
          namespace = "kube-system"
        }
        spec = {
          secretName  = "default-cert"
          duration    = "2160h"
          renewBefore = "360h"
          issuerRef = {
            name = "acme"
            kind = "ClusterIssuer"
          }
          dnsNames = [
            local.dns_name
          ]
        }
      }
    )
  }

  provisioner "local-exec" {
    command     = format("echo '%s'|kubectl apply -f -", self.triggers.manifest)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    on_failure  = continue
    command     = format("echo '%s'|kubectl delete -f -", self.triggers.manifest)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource null_resource default_cert_ready {
  depends_on = [helm_release.cert_manager, kubernetes_secret.cert_manager_credentials, null_resource.cluster_issuer, null_resource.default_cert]
  count      = local.enable_cert_manager ? 1 : 0

  triggers = {
    default_cert = "kube-system/default-cert"
    secret_name  = "default-cert"
  }

  provisioner "local-exec" {
    command     = "until [[ $(kubectl get certificate default-cert -n kube-system -o=jsonpath='{.status.conditions[0].type}'|sed 's/\\x1b\\[[0-9;]*[mGKF]//g') == 'Ready' && $(kubectl get certificate default-cert -n kube-system -o=jsonpath='{.status.conditions[0].status}'|sed 's/\\x1b\\[[0-9;]*[mGKF]//g') == 'True' ]]; do echo 'Waiting for default-cert to be ready...' && sleep 5; done && echo 'default-cert ready'"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}
