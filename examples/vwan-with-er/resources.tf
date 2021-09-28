resource "azurerm_log_analytics_workspace" "logs" {
  location            = module.azure_region.location
  name                = var.log_analytics_workspace_name
  resource_group_name = module.rg.resource_group_name
  sku                 = "PerGB2018"
}
