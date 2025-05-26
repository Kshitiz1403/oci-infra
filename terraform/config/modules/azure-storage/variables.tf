variable "azure_location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central India"
}

variable "storage_account_name" {
  description = "Name of the Azure storage account (must be globally unique)"
  type        = string
  default     = "ocik8sstorage"
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be between 3 and 24 characters, lowercase letters and numbers only."
  }
}

variable "share_name" {
  description = "Name of the Azure file share"
  type        = string
  default     = "oci-k8s-share"
}

variable "share_quota_gb" {
  description = "Size of the Azure file share in GB"
  type        = number
  default     = 100
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "oci-k8s-storage-rg"
}

variable "tags" {
  description = "Tags to apply to Azure resources"
  type        = map(string)
  default = {
    Environment = "production"
    Purpose     = "oci-k8s-storage"
    ManagedBy   = "terraform"
  }
}