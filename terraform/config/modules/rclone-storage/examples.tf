# Example PVC using rclone Google Drive storage
resource "kubernetes_persistent_volume_claim" "example_pvc" {
  count = var.create_example_resources ? 1 : 0

  metadata {
    name      = "rclone-gdrive-example-pvc"
    namespace = "default"
    labels = {
      "app.kubernetes.io/name"     = "rclone-storage"
      "app.kubernetes.io/instance" = "rclone-storage"
      "app.kubernetes.io/component" = "example"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    
    storage_class_name = kubernetes_storage_class.gdrive_hostpath.metadata[0].name
  }
}

# Example Pod that uses the PVC
resource "kubernetes_pod" "example_pod" {
  count = var.create_example_resources ? 1 : 0

  metadata {
    name      = "rclone-gdrive-example-pod"
    namespace = "default"
    labels = {
      "app.kubernetes.io/name"     = "rclone-storage"
      "app.kubernetes.io/instance" = "rclone-storage"
      "app.kubernetes.io/component" = "example"
    }
  }

  spec {
    container {
      name  = "test-container"
      image = "busybox:latest"
      
      command = ["/bin/sh"]
      args    = ["-c", "while true; do echo 'Testing rclone storage' > /data/test.txt; sleep 30; done"]
      
      volume_mount {
        name       = "rclone-storage"
        mount_path = "/data"
      }
      
      resources {
        limits = {
          cpu    = "100m"
          memory = "128Mi"
        }
        requests = {
          cpu    = "50m"
          memory = "64Mi"
        }
      }
    }
    
    volume {
      name = "rclone-storage"
      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.example_pvc[0].metadata[0].name
      }
    }
    
    restart_policy = "Always"
  }

  depends_on = [kubernetes_persistent_volume_claim.example_pvc]
}