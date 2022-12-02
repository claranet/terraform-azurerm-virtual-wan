module "vpn" {
  for_each = var.vpn_gateway_enabled ? toset(["vpn"]) : toset([])
  source   = "./modules/vpn"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  name_prefix = var.name_prefix
  name_slug   = var.name_slug
  name_suffix = var.name_suffix
  custom_name = var.custom_vpn_gateway_name

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.vpn_gateway_logs_categories
  logs_metrics_categories = var.vpn_gateway_logs_metrics_categories
  logs_retention_days     = var.logs_retention_days

  custom_diagnostic_settings_name = var.vpn_gateway_custom_diagnostic_settings_name

  virtual_wan_id = azurerm_virtual_wan.vwan.id
  virtual_hub_id = module.vhub.virtual_hub_id

  vpn_gateway_routing_preference             = var.vpn_gateway_routing_preference
  vpn_gateway_scale_unit                     = var.vpn_gateway_scale_unit
  vpn_gateway_instance_0_bgp_peering_address = var.vpn_gateway_instance_0_bgp_peering_address
  vpn_gateway_instance_1_bgp_peering_address = var.vpn_gateway_instance_1_bgp_peering_address

  vpn_sites = var.vpn_sites

  vpn_connections = var.vpn_connections

  internet_security_enabled = var.internet_security_enabled

  extra_tags = merge(local.tags, var.vpn_gateway_extra_tags)
}
