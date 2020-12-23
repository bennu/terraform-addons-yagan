# Addons

This modules deploys addons for a kubernetes cluster, such as:

- [Kubernetes Authenticating][kubernetes-auth]
    - [dex][dex]
    - [gangway][gangway]
- [cert manager][cert-manager]
- [descheduler][descheduler]
- [gatekeeper][gatekeeper]
- [externalDNS][external-dns]
- [klum][klum]
- [kured][kured]
- [metallb][metallb]
- [nginx ingress controller][nginx-ingress]

*This module requires:*

- [helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- `kubectl` + `kubeconfig` for some custom resources configuration and validations (*until the coming [kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes-alpha/latest/docs) is ready to use*)

## Requirements

| Name | Version |
|------|---------|
| terraform | `>= 0.13` |

# Customization

## General

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addons | Comma-separated list of to-be enabled addons | `string` | `"cert-manager,descheduler,dex,externaldns,gangway,gatekeeper,ingress,klum,kured,metallb"` | no |

**Note:** Version for each add-on is declared in [local.tf](./local.tf#L2)

## Authorization

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dex_expiry_device_requests | Expiry time for device requests | `string` | `"5m"` | no |
| dex_expiry_id_tokens | Expiry time for id token | `string` | `"24h"` | no |
| dex_expiry_signing_keys | Expiry time for signing keys | `string` | `"6h"` | no |
| dex_ldap_bind_dn | LDAP/AD account for Dex | `string` | `""` | no |
| dex_ldap_bind_pw | LDAP/AD account password for Dex | `string` | `""` | no |
| dex_ldap_endpoint | LDAP/AD endpoint for Dex | `string` | `""` | no |
| dex_ldap_groupsearch | Enable LDAP/AD groupsearch | `bool` | `true` | no |
| dex_ldap_groupsearch_basedn | LDAP/AD domain to fetch groupsearch from | `string` | `""` | no |
| dex_ldap_groupsearch_filter | LDAP/AD filter for groupsearch | `string` | `""` | no |
| dex_ldap_groupsearch_groupattr | LDAP/AD group attribute to fetch from groupsearch | `string` | `""` | no |
| dex_ldap_groupsearch_nameattr | LDAP/AD name attribute to fetch from groupsearch | `string` | `""` | no |
| dex_ldap_groupsearch_userattr | LDAP/AD user attribute to fetch from groupsearch | `string` | `""` | no |
| dex_ldap_insecure_no_ssl | Insecure connection to LDAP/AD server | `bool` | `true` | no |
| dex_ldap_ssl_skip_verify | Do not verify TLS certs when connection to LDAP/AD server | `bool` | `true` | no |
| dex_ldap_start_tls | Execute StartTLS operations | `bool` | `false` | no |
| dex_ldap_username_prompt | Username prompt field for LDAP/AD | `string` | `""` | no |
| dex_ldap_usersearch | Enable LDAP/AD usersearch | `bool` | `true` | no |
| dex_ldap_usersearch_basedn | LDAP/AD domain to fetch usersearch from | `string` | `""` | no |
| dex_ldap_usersearch_emailattr | LDAP/AD user attribute to fetch from usersearch | `string` | `""` | no |
| dex_ldap_usersearch_filter | LDAP/AD filter for groupsearch | `string` | `""` | no |
| dex_ldap_usersearch_idattr | LDAP/AD id attribute to fetch from usersearch | `string` | `""` | no |
| dex_ldap_usersearch_nameattr | LDAP/AD name attribute to fetch from usersearch | `string` | `""` | no |
| dex_ldap_usersearch_username | LDAP/AD username to fetch from usersearch | `string` | `""` | no |
| dex_oauth_skip_approval_screen | Show approval screen | `bool` | `true` | no |
| dex_url | FQDN for publishing dex through ingress controller | `string` | `""` | no |
| gangway_api_server_url | Kubernetes API-Server URL for Gangway to print in kubeconfig | `string` | `""` | no |
| gangway_cluster_name | Cluster name for Gangway config | `string` | `""` | no |
| gangway_url | FQDN for publishing gangway through ingress controller | `string` | `""` | no |
| grafana_url | URL for using dex auth in grafana | `string` | `""` | no |

## Descheduler

According to [descheduler config][descheduler-config]

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| descheduler_low_node_utilization | Configure descheduler for balancing workloads in the cluster | `bool` | `true` | no |
| descheduler_rm_duplicates | Cleanup orphan pods | `bool` | `true` | no |
| descheduler_rm_node_affinity_violation | Ensure that pods violating node affinity are removed from nodes | `bool` | `true` | no |
| descheduler_rm_pods_affinity_violation | Ensure that pods violating interpod anti-affinity are removed from nodes | `bool` | `true` | no |
| descheduler_rm_taint_violation | Ensure that pods violating NoSchedule taints on nodes are removed | `bool` | `true` | no |
| target_treshold_cpu | CPU usage percentage for nodes to evict pods from | `number` | `50` | no |
| target_treshold_mem | RAM usage percentage for nodes to evict pods from | `number` | `75` | no |
| target_treshold_pods | Pods ammount for nodes to evict pods from | `number` | `75` | no |
| treshold_cpu | CPU usage percentage for nodes to allocate pods to | `number` | `20` | no |
| treshold_mem | RAM usage percentage for nodes to allocate pods to | `number` | `20` | no |
| treshold_pods | Pods ammount for nodes to allocate pods to | `number` | `20` | no |

## Kured

According to [kured config][kured-config]

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kured_end_time | End time to execute reboot operations | `string` | `"23:59"` | no |
| kured_reboot_days | Days allowed to reboot nodes | `list` | <pre>[<br>  "mon",<br>  "tu",<br>  "we",<br>  "th",<br>  "fr",<br>  "sat",<br>  "sun"<br>]</pre> | no |
| kured_start_time | Start time to execute reboot operations | `string` | `"00:00"` | no |
| kured_timezone | Timezone to set in kured | `string` | `"UTC"` | no |

## Nginx Ingress Controller

According to [ingress config][ingress-config]

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ingress_autoscale | Enable autoscale | `bool` | `true` | no |
| ingress_default_backend_enabled | Deploy default backend for 404 | `bool` | `true` | no |
| ingress_extra_args | Attach extra config | `map` | `{}` | no |
| ingress_max_replicas | Maximum replicas for autoscaling | `number` | `5` | no |
| ingress_metrics_enabled | Enable metrics | `bool` | `false` | no |
| ingress_min_replicas | Minimum replicas for autoscaling | `number` | `1` | no |
| ingress_prometheus_rule_enabled | Add prometheus rule | `bool` | `false` | no |
| ingress_service_monitor_enabled | Add service monitor | `bool` | `false` | no |
| ingress_service_type | Service type for deploying ingress | `string` | `"LoadBalancer"` | no |

## External DNS

**Note 1:** DNS can configure with **AWS (Route 53)** for default, also is possible to use **RFC-2136 (Bind)** for now.

**Note 2:** `zone_id` is used both in **externalDNS** and **cert-manager**, also `dns_zone` is used to build

**Note 3:** Is possible to use same domain to external DNS and cert-manager, but to propose of this repo `dns_zone` and `cert_manager_zone` to manage **external-dns** and **cert-manager** respectively.


| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns_zone | DNS zone to manage | `string` | `""` | no |
| external_dns_aws_access_key | AWS access key to manage DNS zone | `string` | `""` | no |
| external_dns_aws_prefer_cname | Prefer CNAME records | `bool` | `false` | no |
| external_dns_aws_region | AWS region to manage DNS zone | `string` | `"us-east-1"` | no |
| external_dns_aws_secret_key | AWS secret key to manage DNS zone | `string` | `""` | no |
| external_dns_interval | Interval to watch cluster for changes | `string` | `"30s"` | no |
| external_dns_provider | external-dns provider to use as add-on | `string` | `"aws"` | no |
| external_dns_rfc_alg | TSIG Algorithm used in RFC DNS | `string` | `""` | no |
| external_dns_rfc_axfr | enable zone transfers for RFC DNS | `bool` | `false` | no |
| external_dns_rfc_host | DNS zone for RFC server | `string` | `""` | no |
| external_dns_rfc_key | TSIG key used in RFC DNS | `string` | `""` | no |
| external_dns_rfc_port | Default port for RFC DNS | `number` | `53` | no |
| external_dns_rfc_secret | TSIG secret used in RFC DNS | `string` | `""` | no |
| external_dns_rfc_ttl | default RFC DNS record TTL | `string` | `"0s"` | no |
| external_dns_rfc_zone | Zone used on RFC DNS | `string` | `""` | no |
| external_dns_txt_owner_id | Owner used on RFC DNS | `string` | `""` | no |

## Cert manager

**Note 1:** This configures a Let's Encrypt issuer by default with DNS challenge in **AWS**, also is possible to use **RFC-2136** for now.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acme_email | Email for creating acme account | `string` | `""` | no |
| acme_server | Server to fetch LE certs from | `string` | `"production"` | no |
| cert_manager_access_key | AWS access key to manage DNS zone | `string` | `""` | no |
| cert_manager_aws_region | AWS region to manage DNS zone | `string` | `"us-east-1"` | no |
| cert_manager_provider | cert-manager provider to use as add-on | `string` | `"aws"` | no |
| cert_manager_rfc_alg | TSIG Algorithm used in RFC DNS | `string` | `""` | no |
| cert_manager_rfc_key_name | TSIG key used in RFC DNS | `string` | `""` | no |
| cert_manager_rfc_nameserver | Address of authoritative nameserver DNS with port | `string` | `""` | no |
| cert_manager_secret_key | AWS secret key to manage DNS zone | `string` | `""` | no |
| cert_manager_zone | DNS zone to manage certificates | `string` | `""` | no |
| zone_id | DNS zone id to manage | `string` | `""` | no |

## MetalLB

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| metallb_addresses | Range of IPs to configure metallb in layer2 mode | `string` | `""` | no |

<!-- Links -->
[cert-manager]: https://github.com/jetstack/cert-manager#cert-manager
[descheduler-config]: https://github.com/kubernetes-sigs/descheduler#policy-and-strategies
[descheduler]: https://github.com/kubernetes-sigs/descheduler#descheduler-for-kubernetes
[dex]: https://github.com/dexidp/dex#dex---a-federated-openid-connect-provider
[external-dns]: https://github.com/kubernetes-sigs/external-dns#externaldns
[gangway]: https://github.com/heptiolabs/gangway#gangway
[gatekeeper]: https://github.com/open-policy-agent/gatekeeper#gatekeeper
[ingress-config]: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/cli-arguments.md
[klum]: https://github.com/ibuildthecloud/klum#klum---kubernetes-lazy-user-manager
[kubernetes-auth]: https://kubernetes.io/docs/reference/access-authn-authz/authentication/
[kured-config]: https://github.com/weaveworks/kured#configuration
[kured]: https://github.com/weaveworks/kured#kured---kubernetes-reboot-daemon
[metallb]: https://github.com/metallb/metallb#metallb
[nginx-ingress]: https://github.com/kubernetes/ingress-nginx#nginx-ingress-controller