variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"

  default = "ocid1.tenancy.oc1..aaaaaaaazmshxiol4bmgetsexq7e3bgww7jui2o6mdsg62oxpnbmz2pqvfnq"
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "ap-mumbai-1"
}

variable "public_subnet_id" {
  type        = string
  description = "The public subnet's OCID"

  default = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaaupcawd7ikngw56n6fjbn6diz3f5dugkzflwzrfmpmizektl3g4dq"
}

variable "node_pool_id" {
  description = "The OCID of the Node Pool where the compute instances reside"
  type        = string

  default = "ocid1.nodepool.oc1.ap-mumbai-1.aaaaaaaapj3i5mcxapssqgt6n657ca6q3dq4h2scp43gfscr6n2c6g5mcezq"
}

variable "vault_id" {
  description = "OCI Vault OIDC"
  type        = string

  default = "ocid1.vault.oc1.ap-mumbai-1.fbudgg6caadh4.abrg6ljrzxevunglt5nm5jywm4wip5lhls4py7hwdo3hpfo7bcil3txybtea"
}

variable "tenancy_id" {
  description = "Tenancy OCID"
  type        = string

  default = "ocid1.tenancy.oc1..aaaaaaaazmshxiol4bmgetsexq7e3bgww7jui2o6mdsg62oxpnbmz2pqvfnq"
}

variable "gh_token" {
  description = "Github PAT for FluxCD"
  type        = string
  sensitive   = true
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string

  default = "1326003"
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string

  default = "68458163"
}

variable "github_app_pem" {
  description = "The contents of the GitHub App private key PEM file"
  sensitive   = true
  type        = string
}

# Azure Storage Variables
variable "azure_location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central India"
}

variable "azure_storage_account_name" {
  description = "Name of the Azure storage account (must be globally unique)"
  type        = string
  default     = "ocik8sstorage123"
  
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.azure_storage_account_name))
    error_message = "Storage account name must be between 3 and 24 characters, lowercase letters and numbers only."
  }
}

variable "azure_resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "oci-k8s-storage-rg"
}

variable "azure_share_name" {
  description = "Name of the Azure file share"
  type        = string
  default     = "oci-k8s-share"
}

variable "azure_share_quota_gb" {
  description = "Size of the Azure file share in GB"
  type        = number
  default     = 100
}
