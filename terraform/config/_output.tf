# output "longhorn_login" {
#   value = module.longhorn.longhorn_login
#
#   sensitive = true
# }

# Azure Storage Outputs
output "azure_storage_namespace" {
  description = "Kubernetes namespace for Azure storage resources"
  value       = module.azure_storage.azure_storage_namespace
}

output "azure_storage_secret_name" {
  description = "Name of the Kubernetes secret containing Azure storage credentials"
  value       = module.azure_storage.azure_storage_secret_name
  sensitive   = true
}

output "azure_file_storage_class_name" {
  description = "Name of the Azure File Storage Class"
  value       = module.azure_storage.azure_file_storage_class_name
}

output "azure_csi_driver_name" {
  description = "Name of the Azure File CSI driver"
  value       = module.azure_storage.csi_driver_name
}
