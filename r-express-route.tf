module "express_route" {
  for_each = var.express_route_enabled ? toset(["express_route"]) : toset([])
  source   = "./modules/express-route"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_slug   = var.name_slug
  name_suffix = var.name_suffix

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.express_route_logs_categories
  logs_metrics_categories = var.express_route_logs_metrics_categories
  logs_retention_days     = var.logs_retention_days

  custom_diagnostic_settings_name = var.express_route_custom_diagnostic_settings_name

  virtual_hub_id = module.vhub.virtual_hub_id

  express_route_gateway_scale_unit  = var.express_route_gateway_scale_unit
  custom_express_route_gateway_name = var.custom_express_route_gateway_name

  express_route_circuit_bandwidth_in_mbps = var.express_route_circuit_bandwidth_in_mbps
  express_route_circuit_peering_location  = var.express_route_circuit_peering_location
  express_route_circuit_service_provider  = var.express_route_circuit_service_provider
  express_route_sku                       = var.express_route_sku

  custom_express_route_circuit_name                                   = var.custom_express_route_circuit_name
  express_route_private_peering_enabled                               = var.express_route_private_peering_enabled
  express_route_circuit_private_peering_primary_peer_address_prefix   = var.express_route_circuit_private_peering_primary_peer_address_prefix
  express_route_circuit_private_peering_secondary_peer_address_prefix = var.express_route_circuit_private_peering_secondary_peer_address_prefix
  express_route_circuit_private_peering_vlan_id                       = var.express_route_circuit_private_peering_vlan_id
  express_route_circuit_private_peering_shared_key                    = var.express_route_circuit_private_peering_shared_key
  express_route_circuit_private_peering_peer_asn                      = var.express_route_circuit_private_peering_peer_asn

  extra_tags = merge(local.tags, var.express_route_gateway_extra_tags)
}
