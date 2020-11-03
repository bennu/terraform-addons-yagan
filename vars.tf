variable addons {
  description = "Comma-separated list of to-be enabled addons"
  default     = "cert-manager,descheduler,dex,externaldns,gangway,ingress,klum,kured,metallb"
}

# ingress
variable ingress_autoscale {
  description = "Enable autoscale"
  default     = true
}
variable ingress_default_backend_enabled {
  description = "Deploy default backend for 404"
  default     = true
}
variable ingress_extra_args {
  description = "Attach extra config"
  default     = {}
}
variable ingress_max_replicas {
  description = "Maximum replicas for autoscaling"
  default     = 5
}
variable ingress_metrics_enabled {
  description = "Enable metrics"
  default     = false
}
variable ingress_min_replicas {
  description = "Minimum replicas for autoscaling"
  default     = 1
}
variable ingress_prometheus_rule_enabled {
  description = "Add prometheus rule"
  default     = false
}
variable ingress_service_monitor_enabled {
  description = "Add service monitor"
  default     = false
}
variable ingress_service_type {
  description = "Service type for deploying ingress"
  default     = "LoadBalancer"
}

# kured
variable kured_start_time {
  description = "Start time to execute reboot operations"
  default     = "00:00"
}
variable kured_end_time {
  description = "End time to execute reboot operations"
  default     = "23:59"
}
variable kured_reboot_days {
  description = "Days allowed to reboot nodes"
  default     = ["mon", "tu", "we", "th", "fr", "sat", "sun"]
}
variable kured_timezone {
  description = "Timezone to set in kured"
  default     = "UTC"
}

# descheduler LowNodeUtilization config
variable descheduler_low_node_utilization {
  description = "Configure descheduler for balancing workloads in the cluster"
  default     = true
}
variable descheduler_rm_duplicates {
  description = "Cleanup orphan pods"
  default     = true
}
variable descheduler_rm_node_affinity_violation {
  description = "Ensure that pods violating node affinity are removed from nodes"
  default     = true
}
variable descheduler_rm_pods_affinity_violation {
  description = "Ensure that pods violating interpod anti-affinity are removed from nodes"
  default     = true
}
variable descheduler_rm_taint_violation {
  description = "Ensure that pods violating NoSchedule taints on nodes are removed"
  default     = true
}

## treshold for watching nodes with high utilization
variable target_treshold_cpu {
  description = "CPU usage percentage for nodes to evict pods from"
  default     = 50
}
variable target_treshold_mem {
  description = "RAM usage percentage for nodes to evict pods from"
  default     = 75
}
variable target_treshold_pods {
  description = "Pods ammount for nodes to evict pods from"
  default     = 75
}

## treshold for watching nodes with low utilization
variable treshold_cpu {
  description = "CPU usage percentage for nodes to allocate pods to"
  default     = 20
}
variable treshold_mem {
  description = "RAM usage percentage for nodes to allocate pods to"
  default     = 20
}
variable treshold_pods {
  description = "Pods ammount for nodes to allocate pods to"
  default     = 20
}

# auth-related vars
variable dex_expiry_device_requests {
  description = "Expiry time for device requests"
  default     = "5m"
}
variable dex_expiry_id_tokens {
  description = "Expiry time for id token"
  default     = "24h"
}
variable dex_expiry_signing_keys {
  description = "Expiry time for signing keys"
  default     = "6h"
}
variable dex_ldap_bind_dn {
  description = "LDAP/AD account for Dex"
  default     = ""
}
variable dex_ldap_bind_pw {
  description = "LDAP/AD account password for Dex"
  default     = ""
}
variable dex_ldap_endpoint {
  description = "LDAP/AD endpoint for Dex"
  default     = ""
}
variable dex_ldap_groupsearch {
  description = "Enable LDAP/AD groupsearch"
  default     = true
}
variable dex_ldap_groupsearch_basedn {
  description = "LDAP/AD domain to fetch groupsearch from"
  default     = ""
}
variable dex_ldap_groupsearch_filter {
  description = "LDAP/AD filter for groupsearch"
  default     = ""
}
variable dex_ldap_groupsearch_groupattr {
  description = "LDAP/AD group attribute to fetch from groupsearch"
  default     = ""
}
variable dex_ldap_groupsearch_nameattr {
  description = "LDAP/AD name attribute to fetch from groupsearch"
  default     = ""
}
variable dex_ldap_groupsearch_userattr {
  description = "LDAP/AD user attribute to fetch from groupsearch"
  default     = ""
}
variable dex_ldap_insecure_no_ssl {
  description = "Insecure connection to LDAP/AD server"
  default     = true
}
variable dex_ldap_ssl_skip_verify {
  description = "Do not verify TLS certs when connection to LDAP/AD server"
  default     = true
}
variable dex_ldap_start_tls {
  description = "Execute StartTLS operations"
  default     = false
}
variable dex_ldap_username_prompt {
  description = "Username prompt field for LDAP/AD"
  default     = ""
}
variable dex_ldap_usersearch {
  description = "Enable LDAP/AD usersearch"
  default     = true
}
variable dex_ldap_usersearch_basedn {
  description = "LDAP/AD domain to fetch usersearch from"
  default     = ""
}
variable dex_ldap_usersearch_emailattr {
  description = "LDAP/AD user attribute to fetch from usersearch"
  default     = ""
}
variable dex_ldap_usersearch_filter {
  description = "LDAP/AD filter for groupsearch"
  default     = ""
}
variable dex_ldap_usersearch_idattr {
  description = "LDAP/AD id attribute to fetch from usersearch"
  default     = ""
}
variable dex_ldap_usersearch_nameattr {
  description = "LDAP/AD name attribute to fetch from usersearch"
  default     = ""
}
variable dex_ldap_usersearch_username {
  description = "LDAP/AD username to fetch from usersearch"
  default     = ""
}
variable dex_oauth_skip_approval_screen {
  description = "Show approval screen"
  default     = true
}
variable dex_url {
  description = "FQDN for publishing dex through ingress controller"
  default     = ""
}
variable gangway_api_server_url {
  description = "Kubernetes API-Server URL for Gangway to print in kubeconfig"
  default     = ""
}
variable gangway_cluster_name {
  description = "Cluster name for Gangway config"
  default     = ""
}
variable gangway_url {
  description = "FQDN for publishing gangway through ingress controller"
  default     = ""
}
variable grafana_url {
  description = "URL for using dex auth in grafana"
  default     = ""
}

# externaldns vars
variable dns_zone {
  description = "DNS zone to manage"
  default     = ""
}
variable external_dns_access_key {
  description = "AWS access key to manage DNS zone"
  default     = ""
}
variable external_dns_interval {
  description = "Interval to watch cluster for changes"
  default     = "30s"
}
variable external_dns_region {
  description = "AWS region to manage DNS zone"
  default     = "us-east-1"
}
variable external_dns_prefer_cname {
  description = "Prefer CNAME records"
  default     = false
}
variable external_dns_secret_key {
  description = "AWS secret key to manage DNS zone"
  default     = ""
}

# cert-manager
variable acme_email {
  description = "Email for creating acme account"
  default     = ""
}
variable acme_server {
  description = "Server to fetch LE certs from"
  default     = "production"
}
variable cert_manager_access_key {
  description = "AWS access key to manage DNS zone"
  default     = ""
}
variable cert_manager_aws_region {
  description = "AWS region to manage DNS zone"
  default     = "us-east-1"
}
variable cert_manager_secret_key {
  description = "AWS secret key to manage DNS zone"
  default     = ""
}
variable zone_id {
  description = "DNS zone id to manage"
  default     = ""
}

# metallb
variable metallb_addresses {
  description = "Range of IPs to configure metallb in layer2 mode"
  default     = ""
}

# klum
variable klum_api_server_url {
  description = "Kubernetes API-Server URL for Klum to print in kubeconfig"
  default     = "https://localhost:6443"
}
