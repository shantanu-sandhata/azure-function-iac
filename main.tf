# Creating resource group sandhata
resource "azurerm_resource_group" "sandhata" {
  name     = "sandhata"
  location = "centralindia"
  tags = {
    "Name" = "Sandhata"
    "Managed_by" = "Terrafrom"
  }
}

# Creating Storage account
resource "azurerm_storage_account" "sandhata" {
  name                     = "sandhata"
  resource_group_name      = resource.azurerm_resource_group.sandhata.name
  location                 = "centralindia"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  tags = {
    "Name" = "sandhata"
    "Managed_by" = "Terrafrom"
  }
}

# Creating container in storage container
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate-sandhatafunc"
  storage_account_name  = azurerm_storage_account.sandhata.name
  container_access_type = "private"
}

# Creating azure service plan
resource "azurerm_service_plan" "asp_sandhata" {
  name                         = "ASP-sandhata-5e8a"
  resource_group_name          = resource.azurerm_resource_group.sandhata.name
  location                     = resource.azurerm_resource_group.sandhata.location
  os_type                      = "Linux"
  sku_name                     = "Y1"
}