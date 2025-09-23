variable "namespace" {
  description = "Kubernetes namespace for rclone storage"
  type        = string
  default     = "rclone-system"
}

variable "google_drive_client_id" {
  description = "Google Drive OAuth2 client ID"
  type        = string
  sensitive   = true
}

variable "google_drive_client_secret" {
  description = "Google Drive OAuth2 client secret"
  type        = string
  sensitive   = true
}

variable "google_drive_token" {
  description = "Google Drive OAuth2 refresh token (JSON format)"
  type        = string
  sensitive   = true
}

variable "google_drive_refresh_token" {
  description = "Google Drive OAuth2 refresh token"
  type        = string
  sensitive   = true
}

variable "storage_class_name" {
  description = "Name for the rclone storage class"
  type        = string
  default     = "rclone-gdrive"
}

variable "csi_driver_image" {
  description = "Docker image for rclone CSI driver"
  type        = string
  default     = "qrtt1/csi-rclone:v1.2.7.5"
}

variable "csi_node_driver_registrar_image" {
  description = "Docker image for CSI node driver registrar"
  type        = string
  default     = "registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0"
}

variable "csi_provisioner_image" {
  description = "Docker image for CSI provisioner"
  type        = string
  default     = "registry.k8s.io/sig-storage/csi-provisioner:v3.5.0"
}

variable "csi_attacher_image" {
  description = "Docker image for CSI attacher"
  type        = string
  default     = "registry.k8s.io/sig-storage/csi-attacher:v4.3.0"
}

variable "create_example_resources" {
  description = "Whether to create example PVC and Pod for testing"
  type        = bool
  default     = false
}

variable "google_drive_folder_path" {
  description = "Specific folder path in Google Drive to mount (e.g., '/MyFolder/SubFolder'). Leave empty to mount entire drive."
  type        = string
  default     = ""
}

variable "google_drive_root_folder_id" {
  description = "Google Drive folder ID to use as root (alternative to folder_path). You can get this from the folder URL in Google Drive."
  type        = string
  default     = ""
}