module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "4.1.1"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "5.0.1"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtual-wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "5.0.0"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name

  vhub_address_prefix = var.vhub_address_prefix

  enable_firewall      = false
  enable_express_route = false

  logs_destinations_ids = [
    azurerm_log_analytics_workspace.logs.id
  ]
}
