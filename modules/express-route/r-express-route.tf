resource "azurerm_express_route_gateway" "ergw" {
  name                = local.ergw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scale_units         = var.express_route_gateway_scale_unit
  virtual_hub_id      = var.virtual_hub_id

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_express_route_circuit" "erc" {
  name                = local.erc_name
  location            = var.location
  resource_group_name = var.resource_group_name

  bandwidth_in_mbps     = var.express_route_circuit_bandwidth_in_mbps
  peering_location      = var.express_route_circuit_peering_location
  service_provider_name = var.express_route_circuit_service_provider

  sku {
    tier   = var.express_route_sku.tier
    family = var.express_route_sku.family
  }

  tags = var.extra_tags
}

resource "azurerm_express_route_circuit_peering" "ercprivatepeer" {
  for_each                      = var.express_route_private_peering_enabled ? toset(["express_route"]) : toset([])
  resource_group_name           = var.resource_group_name
  express_route_circuit_name    = azurerm_express_route_circuit.erc.name
  peering_type                  = "AzurePrivatePeering"
  primary_peer_address_prefix   = var.express_route_circuit_private_peering_primary_peer_address_prefix
  secondary_peer_address_prefix = var.express_route_circuit_private_peering_secondary_peer_address_prefix
  vlan_id                       = var.express_route_circuit_private_peering_vlan_id
  shared_key                    = var.express_route_circuit_private_peering_shared_key
  peer_asn                      = var.express_route_circuit_private_peering_peer_asn
}
