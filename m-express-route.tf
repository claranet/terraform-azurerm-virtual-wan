module "express_route" {
  source = "./modules/express-route"

  count = var.express_route_enabled ? 1 : 0

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
  name_slug   = var.name_slug

  gateway_custom_name             = var.express_route_gateway_custom_name
  circuit_custom_name             = var.express_route_circuit_custom_name
  diagnostic_settings_custom_name = var.express_route_diagnostic_settings_custom_name

  virtual_hub = module.virtual_hub

  gateway_scale_unit                      = var.express_route_gateway_scale_unit
  gateway_non_virtual_wan_traffic_allowed = var.express_route_gateway_non_virtual_wan_traffic_allowed

  circuit_enabled           = var.express_route_circuit_enabled
  circuit_peering_location  = var.express_route_circuit_peering_location
  circuit_bandwidth_in_mbps = var.express_route_circuit_bandwidth_in_mbps
  circuit_service_provider  = var.express_route_circuit_service_provider
  circuit_sku               = var.express_route_circuit_sku

  private_peering_enabled                       = var.express_route_private_peering_enabled
  private_peering_primary_peer_address_prefix   = var.express_route_private_peering_primary_peer_address_prefix
  private_peering_secondary_peer_address_prefix = var.express_route_private_peering_secondary_peer_address_prefix
  private_peering_shared_key                    = var.express_route_private_peering_shared_key
  private_peering_peer_asn                      = var.express_route_private_peering_peer_asn
  private_peering_vlan_id                       = var.express_route_private_peering_vlan_id

  logs_destinations_ids   = coalesce(var.express_route_logs_destinations_ids, var.logs_destinations_ids)
  logs_categories         = var.express_route_logs_categories
  logs_metrics_categories = var.express_route_logs_metrics_categories

  extra_tags = merge(local.tags, var.express_route_extra_tags)
}

moved {
  from = module.express_route["express_route"]
  to   = module.express_route[0]
}
