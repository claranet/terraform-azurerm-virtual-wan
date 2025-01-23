module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name
}

data "azurerm_virtual_wan" "main" {
  name                = var.virtual_wan_name
  resource_group_name = var.virtual_wan_resource_group_name
}

module "virtual_hub" {
  source  = "claranet/virtual-wan/azurerm//modules/virtual-hub"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_wan = data.azurerm_virtual_wan.main

  address_prefix = "10.0.0.0/23"

  extra_tags = var.extra_tags
}

data "azurerm_firewall" "main" {
  name                = var.firewall_name
  resource_group_name = var.firewall_resource_group_name
}
