provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Use the kubeconfig file from the terraform directory
provider "kubernetes" {
  config_path = "../.kube.config"
}

provider "helm" {
  kubernetes {
    config_path = "../.kube.config"
  }
} 