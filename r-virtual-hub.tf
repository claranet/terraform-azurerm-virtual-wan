module "vhub" {
  source = "./modules/virtual-hub"

  client_name             = var.client_name
  environment             = var.environment
  custom_virtual_hub_name = var.custom_virtual_hub_name

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_slug   = var.name_slug
  name_suffix = var.name_suffix

  stack = var.stack

  virtual_wan_id             = azurerm_virtual_wan.vwan.id
  virtual_hub_address_prefix = var.virtual_hub_address_prefix

  virtual_hub_sku    = var.virtual_hub_sku
  virtual_hub_routes = var.virtual_hub_routes

  peered_virtual_networks   = var.peered_virtual_networks
  internet_security_enabled = var.internet_security_enabled

  extra_tags = merge(local.tags, var.virtual_hub_extra_tags)
}
