resource helm_release external_dns {
  count      = local.enable_externaldns ? 1 : 0
  atomic     = true
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  version    = local.external_dns_version
  set_sensitive {
    name  = "aws.credentials.accessKey"
    value = var.external_dns_aws_access_key
  }
  set_sensitive {
    name  = "aws.credentials.secretKey"
    value = var.external_dns_aws_secret_key
  }
  set_sensitive {
    name  = "rfc2136.tsigSecret"
    value = var.external_dns_rfc_secret
  }
  values = [
    yamlencode(
      {
        provider          = var.external_dns_provider
        aws               = local.external_dns_aws
        rfc2136           = local.external_dns_rfc
        interval          = var.external_dns_interval
        priorityClassName = "system-cluster-critical"
        txtOwnerId        = local.external_dns_txt_owner_id
        zoneIdFilters     = [var.zone_id]
      }
    )
  ]
}
