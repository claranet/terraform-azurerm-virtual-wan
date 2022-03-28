module "vpn" {
  for_each = var.vpn_gateway_enabled ? toset(["vpn"]) : toset([])
  source   = "./modules/vpn"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  custom_vpn_gateway_name = var.custom_vpn_gateway_name

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  logs_destinations_ids = var.logs_destinations_ids

  virtual_wan_id = azurerm_virtual_wan.vwan.id
  virtual_hub_id = module.vhub.virtual_hub_id

  vpn_gateway_routing_preference             = var.vpn_gateway_routing_preference
  vpn_gateway_scale_unit                     = var.vpn_gateway_scale_unit
  vpn_gateway_instance_0_bgp_peering_address = var.vpn_gateway_instance_0_bgp_peering_address
  vpn_gateway_instance_1_bgp_peering_address = var.vpn_gateway_instance_1_bgp_peering_address

  vpn_sites = var.vpn_sites

  vpn_connections = var.vpn_connections




  vpn_gateway_tags = merge(local.tags, var.vpn_gateway_extra_tags)
}
