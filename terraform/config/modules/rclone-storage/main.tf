# Main configuration for rclone Google Drive storage using DaemonSet approach
# This replaces the CSI driver approach with a simpler and more reliable solution

# Create namespace for Google Drive storage
resource "kubernetes_namespace" "gdrive_storage" {
  metadata {
    name = var.namespace
    labels = {
      "name" = var.namespace
    }
  }
}

# Create ConfigMap with rclone configuration
resource "kubernetes_config_map" "rclone_config" {
  metadata {
    name      = "rclone-config"
    namespace = kubernetes_namespace.gdrive_storage.metadata[0].name
  }

  data = {
    "rclone.conf" = <<-EOF
[gdrive]
type = drive
scope = drive
${var.google_drive_root_folder_id != "" ? "root_folder_id = ${var.google_drive_root_folder_id}" : ""}
use_trash = false
acknowledge_abuse = true
keep_revision_forever = false
EOF
  }
}

# Service Account for rclone
resource "kubernetes_service_account" "rclone_sa" {
  metadata {
    name      = "rclone-sa"
    namespace = kubernetes_namespace.gdrive_storage.metadata[0].name
  }
}

# ClusterRole for rclone operations
resource "kubernetes_cluster_role" "rclone_cluster_role" {
  metadata {
    name = "rclone-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "watch", "update"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

# ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "rclone_cluster_role_binding" {
  metadata {
    name = "rclone-cluster-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.rclone_cluster_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.rclone_sa.metadata[0].name
    namespace = kubernetes_namespace.gdrive_storage.metadata[0].name
  }
}

# DaemonSet for rclone mounts on each node
resource "kubernetes_daemonset" "rclone_mount" {
  metadata {
    name      = "rclone-gdrive-mount"
    namespace = kubernetes_namespace.gdrive_storage.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        app = "rclone-gdrive"
      }
    }

    template {
      metadata {
        labels = {
          app = "rclone-gdrive"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.rclone_sa.metadata[0].name
        host_network         = true

        init_container {
          name  = "setup-mount"
          image = "busybox:1.36"
          command = ["sh", "-c"]
          args = [
            "mkdir -p /host/mnt/gdrive && chmod 755 /host/mnt/gdrive"
          ]
          
          volume_mount {
            name       = "host-mount"
            mount_path = "/host"
          }

          security_context {
            privileged = true
          }
        }

        container {
          name  = "rclone"
          image = "rclone/rclone:1.64"

          command = ["sh", "-c"]
          args = [
            "cp /etc/rclone-readonly/rclone.conf /tmp/rclone.conf && chmod 600 /tmp/rclone.conf && rclone mount gdrive:${var.google_drive_folder_path} /mnt/gdrive --config=/tmp/rclone.conf --allow-other --allow-non-empty --vfs-cache-mode=writes --vfs-cache-max-age=1h --vfs-cache-max-size=1G --buffer-size=32M --dir-cache-time=5m --poll-interval=10s --log-level=INFO"
          ]

          env {
            name  = "RCLONE_CONFIG_GDRIVE_CLIENT_ID"
            value = var.google_drive_client_id
          }

          env {
            name  = "RCLONE_CONFIG_GDRIVE_CLIENT_SECRET"
            value = var.google_drive_client_secret
          }

          env {
            name  = "RCLONE_CONFIG_GDRIVE_TOKEN"
            value = "{\"access_token\":\"\",\"token_type\":\"Bearer\",\"refresh_token\":\"${var.google_drive_refresh_token}\",\"expiry\":\"2099-01-01T00:00:00Z\"}"
          }

          security_context {
            privileged = true
            capabilities {
              add = ["SYS_ADMIN"]
            }
          }

          volume_mount {
            name       = "rclone-config"
            mount_path = "/etc/rclone-readonly"
            read_only  = true
          }

          volume_mount {
            name              = "gdrive-mount"
            mount_path        = "/mnt/gdrive"
            mount_propagation = "Bidirectional"
          }

          volume_mount {
            name       = "fuse-device"
            mount_path = "/dev/fuse"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }

          liveness_probe {
            exec {
              command = ["sh", "-c", "test -d /mnt/gdrive"]
            }
            initial_delay_seconds = 30
            period_seconds        = 30
          }
        }

        volume {
          name = "rclone-config"
          config_map {
            name = kubernetes_config_map.rclone_config.metadata[0].name
          }
        }

        volume {
          name = "gdrive-mount"
          host_path {
            path = "/mnt/gdrive"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "host-mount"
          host_path {
            path = "/"
            type = "Directory"
          }
        }

        volume {
          name = "fuse-device"
          host_path {
            path = "/dev/fuse"
          }
        }

        toleration {
          operator = "Exists"
        }
      }
    }
  }
}

# StorageClass for Google Drive using hostPath
resource "kubernetes_storage_class" "gdrive_hostpath" {
  metadata {
    name = "gdrive-storage"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

# PersistentVolume for Google Drive
resource "kubernetes_persistent_volume" "gdrive_pv" {
  metadata {
    name = "gdrive-pv"
  }

  spec {
    capacity = {
      storage = "1Ti"
    }

    access_modes = ["ReadWriteMany"]
    
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name              = kubernetes_storage_class.gdrive_hostpath.metadata[0].name

    persistent_volume_source {
      host_path {
        path = "/mnt/gdrive"
        type = "Directory"
      }
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/os"
            operator = "In"
            values   = ["linux"]
          }
        }
      }
    }
  }
}