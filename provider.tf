# Azure Provider source and version.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.87.0"
    }
  }
}

# Azure provider configuration block.
provider "azurerm" {
  features {}
}