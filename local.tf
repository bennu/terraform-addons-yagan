locals {
  # hardcode versions
  cert_manager_version     = "v1.1.0"
  descheduler_version      = "0.20.0"
  dex_image                = "dexidp/dex:v2.27.0"
  external_dns_version     = "4.3.0"
  gangway_image            = "gcr.io/heptio-images/gangway:v3.2.0"
  gatekeeper_version       = "3.2.0"
  ingress_version          = "3.15.2"
  klum_image               = "ibuildthecloud/klum:v0.0.1-amd64"
  kured_version            = "2.2.1"
  metallb_controller_image = "metallb/controller:v0.9.5"
  metallb_speaker_image    = "metallb/speaker:v0.9.5"

  acme_server              = var.acme_server == "production" ? "https://acme-v02.api.letsencrypt.org/directory" : "https://acme-staging-v02.api.letsencrypt.org/directory"
  cert_manager_secret_name = local.enable_cert_manager ? kubernetes_secret.cert_manager_credentials.0.metadata.0.name : ""
  dns_name                 = format("*.%s", var.dns_zone)
  descheduler_policy = {
    strategies = {
      RemoveDuplicates = {
        enabled = var.descheduler_rm_duplicates
      }
      RemovePodsViolatingNodeTaints = {
        enabled = var.descheduler_rm_taint_violation
      }
      RemovePodsViolatingNodeAffinity = {
        enabled = var.descheduler_rm_node_affinity_violation
        params = {
          nodeAffinityType = [
            "requiredDuringSchedulingIgnoredDuringExecution"
          ]
        }
      }
      RemovePodsViolatingInterPodAntiAffinity = {
        enabled = var.descheduler_rm_pods_affinity_violation
      }
      LowNodeUtilization = {
        enabled = var.descheduler_low_node_utilization
        params = {
          nodeResourceUtilizationThresholds = {
            thresholds = {
              cpu    = var.treshold_cpu
              memory = var.treshold_mem
              pods   = var.treshold_pods
            }
            targetThresholds = {
              cpu    = var.target_treshold_cpu
              memory = var.target_treshold_mem
              pods   = var.target_treshold_pods
            }
          }
        }
      }
    }
  }

  dex_config = {
    dex_expiry_device_requests     = var.dex_expiry_device_requests
    dex_expiry_id_tokens           = var.dex_expiry_id_tokens
    dex_expiry_signing_keys        = var.dex_expiry_signing_keys
    dex_ldap_bind_dn               = var.dex_ldap_bind_dn
    dex_ldap_bind_pw               = var.dex_ldap_bind_pw
    dex_ldap_endpoint              = var.dex_ldap_endpoint
    dex_ldap_groupsearch           = var.dex_ldap_groupsearch
    dex_ldap_groupsearch_basedn    = var.dex_ldap_groupsearch_basedn
    dex_ldap_groupsearch_filter    = var.dex_ldap_groupsearch_filter
    dex_ldap_groupsearch_groupattr = var.dex_ldap_groupsearch_groupattr
    dex_ldap_groupsearch_nameattr  = var.dex_ldap_groupsearch_nameattr
    dex_ldap_groupsearch_userattr  = var.dex_ldap_groupsearch_userattr
    dex_ldap_insecure_no_ssl       = var.dex_ldap_insecure_no_ssl
    dex_ldap_ssl_skip_verify       = var.dex_ldap_ssl_skip_verify
    dex_ldap_start_tls             = var.dex_ldap_start_tls
    dex_ldap_username_prompt       = var.dex_ldap_username_prompt
    dex_ldap_usersearch            = var.dex_ldap_usersearch
    dex_ldap_usersearch_basedn     = var.dex_ldap_usersearch_basedn
    dex_ldap_usersearch_emailattr  = var.dex_ldap_usersearch_emailattr
    dex_ldap_usersearch_filter     = var.dex_ldap_usersearch_filter
    dex_ldap_usersearch_idattr     = var.dex_ldap_usersearch_idattr
    dex_ldap_usersearch_nameattr   = var.dex_ldap_usersearch_nameattr
    dex_ldap_usersearch_username   = var.dex_ldap_usersearch_username
    dex_oauth_skip_approval_screen = var.dex_oauth_skip_approval_screen
    dex_url                        = var.dex_url
    gangway_client_secret          = local.enable_gangway ? random_string.gangway_random_key.1.result : "randomkey" # set for `terraform plan` to work
    gangway_url                    = var.gangway_url
    grafana_url                    = var.grafana_url
  }

  enable_addons       = split(",", var.addons)
  enable_cert_manager = contains(local.enable_addons, "cert-manager")
  enable_descheduler  = contains(local.enable_addons, "descheduler")
  enable_dex          = contains(local.enable_addons, "dex")
  enable_externaldns  = contains(local.enable_addons, "externaldns")
  enable_gangway      = contains(local.enable_addons, "gangway")
  enable_gatekeeper   = contains(local.enable_addons, "gatekeeper")
  enable_ingress      = contains(local.enable_addons, "ingress")
  enable_klum         = contains(local.enable_addons, "klum")
  enable_kured        = contains(local.enable_addons, "kured")
  enable_metallb      = contains(local.enable_addons, "metallb")

  gangway_config = {
    api_server            = var.gangway_api_server_url
    cluster_name          = var.gangway_cluster_name
    dex_url               = var.dex_url
    gangway_client_secret = local.enable_gangway ? random_string.gangway_random_key.1.result : "" # set for `terraform plan` to work
    gangway_url           = var.gangway_url
  }

  ingress_deploy_deps = [local.enable_cert_manager ? null_resource.default_cert_ready : null]
  ingress_extra_args = merge(
    local.enable_cert_manager ? { default-ssl-certificate = null_resource.default_cert_ready.0.triggers.default_cert } : {},
    var.ingress_extra_args
  )

  external_dns_aws = var.external_dns_provider == "aws" ? local.external_dns_aws_config : {}
  external_dns_aws_config = {
    region      = var.external_dns_aws_region
    zoneType    = "public"
    preferCNAME = var.external_dns_aws_prefer_cname
  }

  external_dns_rfc = var.external_dns_provider == "rfc2136" ? local.external_dns_rfc_config : {}
  external_dns_rfc_config = {
    host          = var.external_dns_rfc_host
    minTTL        = var.external_dns_rfc_ttl
    port          = var.external_dns_rfc_port
    tsigAxfr      = var.external_dns_rfc_axfr
    tsigSecretAlg = var.external_dns_rfc_alg
    zone          = var.external_dns_rfc_zone
    tsigKeyname   = var.external_dns_rfc_key
  }
  external_dns_txt_owner_id = var.zone_id == "" ? var.external_dns_txt_owner_id : var.zone_id
  cert_manager_config = {
    provider      = var.cert_manager_provider
    secret_key    = local.cert_manager_secret_name
    dns_zone      = var.cert_manager_zone
    acme_email    = var.acme_email
    acme_server   = local.acme_server
    clusterissuer = format("acme-%s", var.cert_manager_zone)

    zone_id        = var.zone_id
    aws_region     = var.cert_manager_aws_region
    aws_access_key = var.cert_manager_access_key

    rfc_server   = var.cert_manager_rfc_nameserver
    rfc_key_name = var.cert_manager_rfc_key_name
    rfc_alg      = var.cert_manager_rfc_alg
  }
}
