resource helm_release gatekeeper {
  count      = local.enable_gatekeeper ? 1 : 0
  atomic     = true
  chart      = "gatekeeper"
  name       = "gatekeeper"
  namespace  = "kube-system"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  version    = local.gatekeeper_version
}
