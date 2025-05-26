output "azure_storage_namespace" {
  description = "Kubernetes namespace for Azure storage resources"
  value       = kubernetes_namespace.azure_storage.metadata[0].name
}

output "azure_storage_secret_name" {
  description = "Name of the Kubernetes secret containing Azure storage credentials"
  value       = kubernetes_secret.azure_storage_secret.metadata[0].name
  sensitive   = true
}

output "azure_file_storage_class_name" {
  description = "Name of the Azure File Storage Class"
  value       = kubernetes_storage_class.azure_file.metadata[0].name
}

output "csi_driver_name" {
  description = "Name of the Azure File CSI driver"
  value       = helm_release.azure_file_csi_driver.name
}

output "storage_account_name" {
  description = "Name of the Azure storage account"
  value       = azurerm_storage_account.oci_storage.name
}

output "storage_account_key" {
  description = "Primary access key for the Azure storage account"
  value       = azurerm_storage_account.oci_storage.primary_access_key
  sensitive   = true
}

output "share_name" {
  description = "Name of the Azure file share"
  value       = azurerm_storage_share.oci_share.name
}

output "share_quota_gb" {
  description = "Size of the Azure file share in GB"
  value       = azurerm_storage_share.oci_share.quota
}

output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.storage_rg.name
}