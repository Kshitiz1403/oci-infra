# Azure Storage Account for OCI Kubernetes integration
resource "azurerm_resource_group" "storage_rg" {
  name     = var.resource_group_name
  location = var.azure_location

  tags = var.tags
}

resource "azurerm_storage_account" "oci_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = var.tags
}

resource "azurerm_storage_share" "oci_share" {
  name                 = var.share_name
  storage_account_name = azurerm_storage_account.oci_storage.name
  quota                = var.share_quota_gb
}

# Kubernetes namespace for Azure storage resources
resource "kubernetes_namespace" "azure_storage" {
  metadata {
    name = "azure-storage"
    labels = {
      "app.kubernetes.io/name"       = "azure-storage"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Kubernetes secret for Azure storage credentials
resource "kubernetes_secret" "azure_storage_secret" {
  metadata {
    name      = "azure-storage-secret"
    namespace = kubernetes_namespace.azure_storage.metadata[0].name
  }

  data = {
    azurestorageaccountname = azurerm_storage_account.oci_storage.name
    azurestorageaccountkey  = azurerm_storage_account.oci_storage.primary_access_key
  }

  type = "Opaque"
}

# Storage Class for Azure File Share
resource "kubernetes_storage_class" "azure_file" {
  metadata {
    name = "azure-file"
    labels = {
      "app.kubernetes.io/name"       = "azure-file-storage"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  storage_provisioner    = "file.csi.azure.com"
  reclaim_policy         = "Retain"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true

  parameters = {
    skuName        = "Standard_LRS"
    resourceGroup   = azurerm_resource_group.storage_rg.name
    storageAccount = azurerm_storage_account.oci_storage.name
  }
}

# Azure File CSI Driver installation via Helm
resource "helm_release" "azure_file_csi_driver" {
  name       = "file-csi-driver"
  repository = "https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/master/charts"
  chart      = "azurefile-csi-driver"
  version    = "v1.32.1"
  namespace  = kubernetes_namespace.azure_storage.metadata[0].name

  set {
    name  = "controller.replicas"
    value = "1"
  }
}