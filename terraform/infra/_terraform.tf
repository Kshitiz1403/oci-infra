terraform {

  backend "s3" {
    bucket                      = "terraform-states"
    key                         = "infra/terraform.tfstate"
    endpoint                    = "https://bm6lssjpwvgb.compat.objectstorage.ap-mumbai-1.oraclecloud.com"
    region                      = "ap-mumbai-1"
    access_key                  = "<Redacted>"
    secret_key                  = "<Redacted>"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }

  required_providers {
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.1"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 6.35.0"
    }
  }
}
