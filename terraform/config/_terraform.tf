terraform {
  #backend "http" {

  #  address        = "https://api.tfstate.dev/github/v1"
  #  lock_address   = "https://api.tfstate.dev/github/v1/lock"
  #  unlock_address = "https://api.tfstate.dev/github/v1/lock"
  #  lock_method    = "PUT"
  #  unlock_method  = "DELETE"
  #  username       = "nce/oci-free-cloud-k8s"
  #}

  backend "s3" {
    bucket                      = "terraform-states"
    key                         = "config/terraform.tfstate"
    endpoint                    = "https://bm6lssjpwvgb.compat.objectstorage.ap-mumbai-1.oraclecloud.com"
    region                      = "ap-mumbai-1"
    access_key                  = "34ee1a07f7a8c974b3280da5500d9736358cd415"
    secret_key                  = "NXthKTVfFH94NNALcWVUKQtaYDBfzyDe6+l7Dg28mdc="
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }

  required_providers {
    oci = {
      source = "oracle/oci"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
