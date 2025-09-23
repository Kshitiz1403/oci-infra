output "namespace" {
  description = "The namespace where Google Drive storage is deployed"
  value       = kubernetes_namespace.gdrive_storage.metadata[0].name
}

output "storage_class_name" {
  description = "The name of the Google Drive storage class"
  value       = kubernetes_storage_class.gdrive_hostpath.metadata[0].name
}

output "persistent_volume_name" {
  description = "The name of the Google Drive persistent volume"
  value       = kubernetes_persistent_volume.gdrive_pv.metadata[0].name
}

output "daemonset_name" {
  description = "The name of the rclone DaemonSet"
  value       = kubernetes_daemonset.rclone_mount.metadata[0].name
}

output "service_account_name" {
  description = "The name of the rclone service account"
  value       = kubernetes_service_account.rclone_sa.metadata[0].name
}