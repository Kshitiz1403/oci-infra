module "externalsecrets" {
  source = "./modules/external-secrets"

  compartment_id = var.compartment_id
  tenancy_id     = var.tenancy_id
  vault_id       = var.vault_id
  region         = var.region
}

module "ingress" {
  source = "./modules/nginx-ingress"

  compartment_id = var.compartment_id
}
