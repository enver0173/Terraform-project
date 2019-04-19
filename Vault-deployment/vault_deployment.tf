resource "kubernetes_persistent_volume_claim" "vault_pvc" {
  # depends_on = ["kubernetes_secret.vault_secret"]
  metadata {
    name      = "vault-pvc"
    namespace = "tools"
    labels {
      app = "vault-deployment"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "10Gi"
      }
    }
  }
}
resource "kubernetes_deployment" "vault" {
  # depends_on = ["kubernetes_secret.vault_secret"]
  metadata {
    name      = "vault"
    namespace = "tools"
    labels {
      app = "vault-deployment"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels {
        app = "vault-deployment"
      }
    }

    template {
      metadata {
        labels {
          app = "vault-deployment"
        }
      }

      spec {
        volume {
          name = "vault-pvc"
          persistent_volume_claim {
            claim_name = "vault-pvc"
          }
        }
        container {
          name  = "vault"
          image = "vault"
          port {
            container_port = 8200
            protocol       = "TCP"
          }
          security_context {
            # allow_privilege_escalation = false
            capabilities {
              add = ["IPC_LOCK"]
            }
            # privileged = true
            # run_as_non_root = true
         
            # privileged = false
            # run_as_non_root = true
            # run_as_user = 10001
          }
          env {
          #   name  = "vault-token"
          #   value = "${var.vault_token}"
          # }
              secret_key_ref {
                name = "vault-secret"
                key  = "token"
              }
            }
          # }
          # env_from {
          #   secret_ref {
          #     name = "vualt-secret"
          #   }
          # }
          volume_mount {
            name       = "vault-pvc"
            mount_path = "/var/run"
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "vault_service" {
  # depends_on = ["kubernetes_secret.vault_secret"]
  metadata {
    name      = "vault-service"
    namespace = "tools"
  }
  
  spec {
    selector { app = "vault-deployment"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8200
    }
    type = "LoadBalancer"
  }
}