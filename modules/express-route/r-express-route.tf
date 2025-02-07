resource "azurerm_express_route_gateway" "main" {
  name     = local.gateway_name
  location = var.location

  resource_group_name = var.resource_group_name

  virtual_hub_id = var.virtual_hub.id

  scale_units                   = var.gateway_scale_unit
  allow_non_virtual_wan_traffic = var.gateway_non_virtual_wan_traffic_allowed

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_express_route_gateway.ergw
  to   = azurerm_express_route_gateway.main
}

resource "azurerm_express_route_circuit" "main" {
  count = var.circuit_enabled ? 1 : 0

  name     = local.circuit_name
  location = var.location

  resource_group_name = var.resource_group_name

  peering_location      = var.circuit_peering_location
  bandwidth_in_mbps     = var.circuit_bandwidth_in_mbps
  service_provider_name = var.circuit_service_provider

  sku {
    tier   = var.circuit_sku.tier
    family = var.circuit_sku.family
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_express_route_circuit.erc
  to   = azurerm_express_route_circuit.main[0]
}

resource "azurerm_express_route_circuit_peering" "main" {
  count = var.private_peering_enabled ? length(azurerm_express_route_circuit.main) : 0

  resource_group_name = var.resource_group_name

  express_route_circuit_name = one(azurerm_express_route_circuit.main[*].name)

  peering_type                  = "AzurePrivatePeering"
  primary_peer_address_prefix   = var.private_peering_primary_peer_address_prefix
  secondary_peer_address_prefix = var.private_peering_secondary_peer_address_prefix
  shared_key                    = var.private_peering_shared_key
  peer_asn                      = var.private_peering_peer_asn
  vlan_id                       = var.private_peering_vlan_id
}

moved {
  from = azurerm_express_route_circuit_peering.ercprivatepeer["express_route"]
  to   = azurerm_express_route_circuit_peering.main[0]
}
