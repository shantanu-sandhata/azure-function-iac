# Creating resource group sandhata
resource "azurerm_resource_group" "sandhata" {
  name     = "sandhata"
  location = "centralindia"
  tags = {
    "Name"       = "Sandhata"
    "Managed_by" = "Terrafrom"
    "Project"    = var.project
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
    "Name"       = "sandhata"
    "Managed_by" = "Terrafrom"
    "Project"    = var.project
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
  name                = "ASP-sandhata-5e8a"
  resource_group_name = resource.azurerm_resource_group.sandhata.name
  location            = resource.azurerm_resource_group.sandhata.location
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = {
    "Name"       = "ASP-sandhata-5e8a"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }

}

# Creating a log analytics workspace
resource "azurerm_log_analytics_workspace" "sandhata" {
  name                = "DefaultWorkspace-6f6b6f42-7704-42fa-b07a-9db961090f1b-CIN"
  resource_group_name = "defaultresourcegroup-cin"
  location            = "centralindia"
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    "Name" = "DefaultWorkspace-6f6b6f42-7704-42fa-b07a-9db961090f1b-CIN"
    "Managed_by" = "Terraform"
    "Project" = var.project
  }
}

# Creating a app insight resource
resource "azurerm_application_insights" "sandhata" {
  name                = "sandhata\\"
  resource_group_name = resource.azurerm_resource_group.sandhata.name
  location            = resource.azurerm_resource_group.sandhata.location
  application_type    = "web"
  sampling_percentage = 0
  workspace_id        = "/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourceGroups/DefaultResourceGroup-CIN/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-6f6b6f42-7704-42fa-b07a-9db961090f1b-CIN"

  tags = {
    "Name" = "${var.default_name}\\"
    "Managed_by" = "Terraform"
    "Project" = var.project
  }
}

# Creating action group to send notifications
resource "azurerm_monitor_action_group" "funcappag" {
}