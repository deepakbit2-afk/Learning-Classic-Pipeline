terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stgtfstate4799"
    container_name       = "tfstate"
    key                  = "staging/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
provider "azurerm" {
  features {}
}