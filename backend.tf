terraform {
    backend "azurerm" {
      resource_group_name = "sandhata"
      storage_account_name = "sandhata"
      container_name = "tfstate-sandhatafunc"
      key = "sandhatafunc.tfstate"
    }
}