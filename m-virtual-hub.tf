module "virtual_hub" {
  source = "./modules/virtual-hub"

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
  name_slug   = var.name_slug

  custom_name = var.virtual_hub_custom_name

  virtual_wan = azurerm_virtual_wan.main

  sku                     = var.virtual_hub_sku
  address_prefix          = var.virtual_hub_address_prefix
  routes                  = var.virtual_hub_routes
  peered_virtual_networks = var.peered_virtual_networks

  internet_security_enabled = var.internet_security_enabled

  extra_tags = merge(local.tags, var.virtual_hub_extra_tags)
}

moved {
  from = module.vhub
  to   = module.virtual_hub
}
