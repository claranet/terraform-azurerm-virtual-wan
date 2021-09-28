module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  vhub_address_prefix = var.vhub_address_prefix

  enable_firewall      = true
  enable_express_route = false

  logs_destinations_ids = [
    azurerm_log_analytics_workspace.logs.id
  ]
}
