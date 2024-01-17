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
    "Name"       = "DefaultWorkspace-6f6b6f42-7704-42fa-b07a-9db961090f1b-CIN"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }
}

# Creating a app insight resource
resource "azurerm_application_insights" "sandhata" {
  name                = "sandhata\\"
  resource_group_name = azurerm_resource_group.sandhata.name
  location            = azurerm_resource_group.sandhata.location
  application_type    = "web"
  sampling_percentage = 0
  workspace_id        = "/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourceGroups/DefaultResourceGroup-CIN/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-6f6b6f42-7704-42fa-b07a-9db961090f1b-CIN"

  tags = {
    "Name"       = "${var.default_name}\\"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }
}

# Creating action group to send notifications
resource "azurerm_monitor_action_group" "funcappag" {
  name                = "FunctionApp%20AG"
  resource_group_name = azurerm_resource_group.sandhata.name
  short_name          = "Func Alerts"

  email_receiver {
    email_address           = "shantanu.inamdar@sandhata.com"
    name                    = "Function -Email  Alert_-EmailAction-"
    use_common_alert_schema = false
  }

  tags = {
    "Name"       = "FunctionApp%20AG"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }

}

# Creating alert rule - http 4xx
resource "azurerm_monitor_metric_alert" "http_4xx" {
  name                = "Sandhata%20Func%20hass%20more%20than%205%20Http%204XX%20error"
  resource_group_name = azurerm_resource_group.sandhata.name
  scopes              = ["/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourceGroups/sandhata/providers/Microsoft.Web/sites/sandhata"]
  description         = "There are more than 5 Http 4XX error FunctionApp - Sandhata."
  severity            = 2

  criteria {
    aggregation            = "Total"
    metric_name            = "Http4xx"
    metric_namespace       = "Microsoft.Web/sites"
    operator               = "GreaterThanOrEqual"
    skip_metric_validation = false
    threshold              = 5
  }

  action {
    action_group_id = "/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourcegroups/sandhata/providers/microsoft.insights/actiongroups/functionapp ag"
  }

  tags = {
    "Name"       = "Sandhata Func has more than 5 http 4xx error"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }
}

# Creating alert rule - Response time
resource "azurerm_monitor_metric_alert" "resp_time" {
  name                = "Sandhata%20Func%20Respose%20Time%20greater%20than%204%20sec"
  resource_group_name = azurerm_resource_group.sandhata.name
  scopes              = ["/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourceGroups/sandhata/providers/Microsoft.Web/sites/sandhata"]
  description         = "The Avg response time for FunctionApp - Sandhata is greater than 4 sec."
  severity            = 2
  window_size         = "PT15M"
  frequency           = "PT5M"

  criteria {
    aggregation            = "Average"
    metric_name            = "HttpResponseTime"
    metric_namespace       = "Microsoft.Web/sites"
    operator               = "GreaterThan"
    skip_metric_validation = false
    threshold              = 4
  }

  action {
    action_group_id    = "/subscriptions/6f6b6f42-7704-42fa-b07a-9db961090f1b/resourcegroups/sandhata/providers/microsoft.insights/actiongroups/functionapp ag"
    webhook_properties = {}
  }

  tags = {
    "Name"       = "Sandhata Func response time is greater than 4 sec"
    "Managed_by" = "Terraform"
    "Project"    = var.project
  }
}