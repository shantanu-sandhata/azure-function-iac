# Creating resource group sandhata
resource "azurerm_resource_group" "sandhata" {
  name     = "sandhata"
  location = "centralindia"
  tags = {
    "Name" = "Sandhata"
  }
}

# Creating Storage account
resource "azurerm_storage_account" "sandhata" {
  name                              = "sandhata" 
  resource_group_name               = "sandhata"
  location                          = "centralindia"
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"

  tags ={
    "Name" = "sandhata"
  }
}