# Addons

This modules deploys addons for a kubernetes cluster, such as:

- Authorization
    - [dex][dex]
    - [gangway][gangway]
- [cert manager][cert-manager]
- [descheduler][descheduler]
- [externalDNS][external-dns]
- [klum][klum]
- [kured][kured]
- [metallb][metallb]
- [nginx ingress controller][nginx-ingress]

# Customization

## General

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`enable_addons`|Comma-separated list of to-be enabled addons||`cert-manager,descheduler,dex,externaldns,gangway,ingress,klum,kured,metallb`|

**Note:** Version for each add-on is declared in [local.tf](./local.tf#L3-12)

## Authorization

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`dex_expiry_device_requests`|Expiry time for device requests||`5m`|
|`dex_expiry_id_tokens`|Expiry time for id token||`24h`|
|`dex_expiry_signing_keys`|Expiry time for signing keys||`6h`|
|`dex_ldap_bind_dn`|LDAP/AD account for Dex|X||
|`dex_ldap_bind_pw`|LDAP/AD account password for Dex|X||
|`dex_ldap_endpoint`|LDAP/AD endpoint for Dex|X||
|`dex_ldap_groupsearch_basedn`|LDAP/AD domain to fetch groupsearch from|X||
|`dex_ldap_groupsearch_filter`|LDAP/AD filter for groupsearch|X||
|`dex_ldap_groupsearch_groupattr`|LDAP/AD group attribute to fetch from groupsearch|X||
|`dex_ldap_groupsearch_nameattr`|LDAP/AD name attribute to fetch from groupsearch|X||
|`dex_ldap_groupsearch_userattr`|LDAP/AD user attribute to fetch from groupsearch|X||
|`dex_ldap_groupsearch`|Enable LDAP/AD groupsearch||`true`|
|`dex_ldap_insecure_no_ssl`|Insecure connection to LDAP/AD server||`true`|
|`dex_ldap_ssl_skip_verify`|Do not verify TLS certs when connection to LDAP/AD server||`true`|
|`dex_ldap_start_tls`|Execute Start/TLS operations||`false`|
|`dex_ldap_username_prompt`|Username prompt field for LDAP/AD|X||
|`dex_ldap_usersearch_basedn`|LDAP/AD domain to fetch usersearch from|X||
|`dex_ldap_usersearch_emailattr`|LDAP/AD user attribute to fetch from usersearch|X||
|`dex_ldap_usersearch_filter`|LDAP/AD filter for groupsearch|X||
|`dex_ldap_usersearch_idattr`|LDAP/AD id attribute to fetch from usersearch|X||
|`dex_ldap_usersearch_nameattr`|LDAP/AD name attribute to fetch from usersearch|X||
|`dex_ldap_usersearch_username`|LDAP/AD username to fetch from usersearch|||
|`dex_ldap_usersearch`|Enable LDAP/AD usersearch||`true`|
|`dex_oauth_skip_approval_screen`|Show approval screen||`true`|
|`dex_url`|FQDN for publishing dex through ingress controller|X||
|`gangway_api_server_url`|Kubernetes API-Server URL for Gangway to connect to|||
|`gangway_cluster_name`|Cluster name for Gangway config|X||
|`gangway_url`|FQDN for publishing gangway through ingress controller|X||
|`grafana_url`|URL for using dex auth in grafana||`""`|

## Descheduler

According to [descheduler config][descheduler-config]

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`descheduler_low_node_utilization`|Configure descheduler for balancing workloads in the cluster||`true`|
|`descheduler_rm_duplicates`|Cleanup orphan pods||`true`|
|`descheduler_rm_node_affinity_violation`|Ensure that pods violating node affinity are removed from nodes||`true`|
|`descheduler_rm_pods_affinity_violation`|Ensure that pods violating interpod anti-affinity are removed from nodes||`true`|
|`descheduler_rm_taint_violation`|Ensure that pods violating NoSchedule taints on nodes are removed||`true`|
|`target_treshold_cpu`|CPU usage percentage for nodes to evict pods from||`50`|
|`target_treshold_mem`|RAM usage percentage for nodes to evict pods from||`75`|
|`target_treshold_pods`|Pods ammount for nodes to evict pods from||`20`|
|`treshold_cpu`|CPU usage percentage for nodes to allocate pods to||`20`|
|`treshold_mem`|RAM usage percentage for nodes to allocate pods to||`20`|
|`treshold_pods`|Pods ammount for nodes to allocate pods to||`8`|

## Kured

According to [kured config][kured-config]

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`kured_start_time`|Star time to execute reboot operations||`22:00`|
|`kured_end_time`|End time to execute reboot operations||`6:00`|
|`kured_reboot_days`|Days allowed to reboot nodes||`["mon", "sat", "sun"]`|
|`kured_timezone`|Timezone to set in kured||`America/Santiago`|

## Nginx ingress controller

According to [ingress config][ingress-config]

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`ingress_autoscale`|Enable autoscale||`[]`|
|`ingress_default_backend_enabled`|Deploy default backend for 404||`true`|
|`ingress_extra_args`|Attach extra config||`[]`|
|`ingress_metrics_enabled`|Enable metrics||`true`|
|`ingress_min_replicas`|Minimum replicas for autoscaling||`1`|
|`ingress_max_replicas`|Maximum replicas for autoscaling||`5`|
|`ingress_prometheus_rule_enabled`|Add prometheus rule||`false`|
|`ingress_service_monitor_enabled`|Add service monitor||`false`|
|`ingress_service_type`|Service type for deploying ingress||`LoadBalancer`|

## External DNS

**Note:** This is only configure to work with AWS for now.

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`dns_zone`|DNS zone to manage||`""`|
|`external_dns_access_key`|AWS access key to manage DNS zone||`""`|
|`external_dns_interval`|Interval to watch cluster for changes||`30s`|
|`external_dns_region`|AWS region to manage DNS zone||`us-east-1`|
|`external_dns_prefer_cname`|Prefer CNAME records||`true`|
|`external_dns_secret_key`|AWS secret key to manage DNS zone||`""`|

## Cert manager

**Note 1:** This configures a Let's Encrypt issuer by default with DNS challenge in AWS

**Note 2:**`zone_id` is used both in externalDNS and Cert manager

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`acme_email`|Email for creating acme account||`""`|
|`acme_server`|Server to fetch LE cert from||`"production"`|
|`cert_manager_access_key`|AWS access key to manage DNS zone||`30s`|
|`cert_manager_aws_region`|AWS region to manage DNS zone||`us-east-1`|
|`cert_manager_secret_key`|AWS secret key to manage DNS zone||`""`|
|`zone_id`|Prefer CNAME records||`true`|

## MetalLB

**Note:** This is only configure to work with AWS for now.

|Variable|Description|Required|Default|
|:---|---|:---:|:---|
|`metallb_addresses`|Range of IPs to configure metallb in layer2 mode||`""`|

<!-- Links -->
[cert-manager]: https://github.com/jetstack/cert-manager
[descheduler-config]: https://github.com/kubernetes-sigs/descheduler#policy-and-strategies
[descheduler]: https://github.com/kubernetes-sigs/descheduler
[dex]: https://github.com/dexidp/dex
[external-dns]: https://github.com/kubernetes-sigs/external-dns
[gangway]: https://github.com/heptiolabs/gangway
[ingress-config]: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/cli-arguments.md
[klum]: https://github.com/ibuildthecloud/klum
[kured-config]: https://github.com/weaveworks/kured#configuration
[kured]: https://github.com/weaveworks/kured
[metallb]: https://github.com/metallb/metallb
[nginx-ingress]: https://github.com/kubernetes/ingress-nginx
