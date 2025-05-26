variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "vault_id" {
  type        = string
  description = "The OCID of the Vault to store the secrets in"
}

variable "tenancy_id" {
  type        = string
  description = "The OCID of the tenancy"
}

variable "region" {
  type        = string
  description = "The region to create the resources in"
}
