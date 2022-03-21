module "vhub" {
  source = "./modules/virtual-hub"

  client_name             = var.client_name
  environment             = var.environment
  custom_virtual_hub_name = var.custom_virtual_hub_name

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  logs_destinations_ids = var.logs_destinations_ids
  stack                 = var.stack

  virtual_wan_id             = azurerm_virtual_wan.vwan.id
  virtual_hub_address_prefix = var.virtual_hub_address_prefix

  virtual_hub_sku    = var.virtual_hub_sku
  virtual_hub_routes = var.virtual_hub_routes

  peered_virtual_networks = var.peered_virtual_networks

  virtual_hub_tags = merge(local.tags, var.virtual_hub_extra_tags)
}
