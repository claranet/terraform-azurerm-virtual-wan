module "vpn" {
  source = "./modules/vpn"

  count = var.vpn_gateway_enabled ? 1 : 0

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
  name_slug   = var.name_slug

  custom_name                     = var.vpn_gateway_custom_name
  diagnostic_settings_custom_name = var.vpn_gateway_diagnostic_settings_custom_name

  virtual_wan = azurerm_virtual_wan.main
  virtual_hub = module.virtual_hub

  scale_unit                     = var.vpn_gateway_scale_unit
  routing_preference             = var.vpn_gateway_routing_preference
  bgp_peer_weight                = var.vpn_gateway_bgp_peer_weight
  instance_0_bgp_peering_address = var.vpn_gateway_instance_0_bgp_peering_address
  instance_1_bgp_peering_address = var.vpn_gateway_instance_1_bgp_peering_address

  vpn_sites       = var.vpn_sites
  vpn_connections = var.vpn_connections

  internet_security_enabled = var.internet_security_enabled

  nat_rules = var.nat_rules

  logs_destinations_ids   = coalesce(var.vpn_gateway_logs_destinations_ids, var.logs_destinations_ids)
  logs_categories         = var.vpn_gateway_logs_categories
  logs_metrics_categories = var.vpn_gateway_logs_metrics_categories

  extra_tags = merge(local.tags, var.vpn_gateway_extra_tags)
}

moved {
  from = module.vpn["vpn"]
  to   = module.vpn[0]
}
