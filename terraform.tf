terraform {
  required_version = "~>1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.18"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  subscription_id = var.landing_zone_subscription_id == "" ? null : var.landing_zone_subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
}

provider "github" {
  token = var.github_personal_access_token
  owner = var.github_organization_name
}
