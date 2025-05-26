module "externalsecrets" {
  source = "./modules/external-secrets"

  compartment_id = var.compartment_id
  tenancy_id     = var.tenancy_id
  vault_id       = var.vault_id
  region         = var.region

  depends_on = [
    module.fluxcd
  ]
}

module "fluxcd" {
  source = "./modules/fluxcd"

  gh_token                   = var.gh_token
  compartment_id             = var.compartment_id
  github_app_id              = var.github_app_id
  github_app_installation_id = var.github_app_installation_id
  github_app_pem             = var.github_app_pem
  
}


module "ingress" {
  source = "./modules/nginx-ingress"

  compartment_id = var.compartment_id
}

module "azure_storage" {
  source = "./modules/azure-storage"

  azure_location        = var.azure_location
  storage_account_name  = var.azure_storage_account_name
  resource_group_name   = var.azure_resource_group_name
  share_name           = var.azure_share_name
  share_quota_gb       = var.azure_share_quota_gb
}
