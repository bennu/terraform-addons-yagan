# https://raw.githubusercontent.com/ibuildthecloud/klum/master/deploy.yaml

resource kubernetes_namespace klum {
  count = local.enable_klum ? 1 : 0
  metadata {
    name = "klum"
    labels = {
      "app" = "klum"
    }
  }
}

resource kubernetes_service_account klum {
  count = local.enable_klum ? 1 : 0
  metadata {
    name      = "klum"
    namespace = kubernetes_namespace.klum.0.metadata.0.name
    labels = {
      "app" = "klum"
    }
  }

  automount_service_account_token = true
}

resource kubernetes_cluster_role_binding klum {
  count = local.enable_klum ? 1 : 0
  metadata {
    name = "klum-cluster-admin"
    labels = {
      "app" = "klum"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.klum.0.metadata.0.name
    namespace = kubernetes_service_account.klum.0.metadata.0.namespace
  }
}

resource kubernetes_deployment klum {
  count = local.enable_klum ? 1 : 0
  metadata {
    name      = "klum"
    namespace = kubernetes_namespace.klum.0.metadata.0.name
    labels = {
      "app" = "klum"
    }
  }

  spec {
    selector {
      match_labels = {
        "app" = "klum"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "klum"
        }
      }

      spec {
        automount_service_account_token = true
        priority_class_name             = "system-cluster-critical"
        service_account_name            = kubernetes_service_account.klum.0.metadata.0.name
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node-role.kubernetes.io/controlplane"
                  operator = "Exists"
                }
              }
            }
          }
        }

        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/controlplane"
          operator = "Equal"
          value    = "true"
        }

        container {
          image = local.klum_image
          name  = "klum"
          env {
            name  = "SERVER_NAME"
            value = var.klum_api_server_url
          }
        }
      }
    }
  }
}
