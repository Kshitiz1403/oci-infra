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

module "rclone_storage" {
  source = "./modules/rclone-storage"

  google_drive_client_id      = var.google_drive_client_id
  google_drive_client_secret  = var.google_drive_client_secret
  google_drive_token          = var.google_drive_token
  google_drive_refresh_token  = var.google_drive_token  # Using the same token as refresh token
  google_drive_folder_path    = var.google_drive_folder_path
  google_drive_root_folder_id = var.google_drive_root_folder_id
}

