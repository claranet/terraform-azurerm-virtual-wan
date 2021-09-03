resource "azurerm_express_route_gateway" "ergw" {
  for_each            = var.enable_express_route ? toset(["express_route"]) : toset([])
  name                = local.ergw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scale_units         = var.er_scale_unit
  virtual_hub_id      = azurerm_virtual_hub.vhub.id

  tags = merge(local.tags, var.ergw_exta_tags)
}

resource "azurerm_express_route_circuit" "erc" {
  for_each            = var.enable_express_route ? toset(["express_route"]) : toset([])
  name                = local.erc_name
  location            = var.location
  resource_group_name = var.resource_group_name

  bandwidth_in_mbps     = var.erc_bandwidth_in_mbps
  peering_location      = var.erc_peering_location
  service_provider_name = var.erc_service_provider

  sku {
    tier   = var.er_sku.tier
    family = var.er_sku.family
  }

  tags = merge(local.tags, var.ergw_exta_tags)
}

resource "azurerm_express_route_circuit_peering" "ercprivatepeer" {
  for_each                      = var.enable_express_route ? var.enable_er_private_peering ? toset(["express_route"]) : toset([]) : toset([])
  resource_group_name           = var.resource_group_name
  express_route_circuit_name    = azurerm_express_route_circuit.erc["express_route"].name
  peering_type                  = "AzurePrivatePeering"
  primary_peer_address_prefix   = var.erc_private_peering_primary_peer_address_prefix
  secondary_peer_address_prefix = var.erc_private_peering_secondary_peer_address_prefix
  vlan_id                       = var.erc_private_peering_vlan_id
  shared_key                    = var.erc_private_peering_shared_key
  peer_asn                      = var.erc_private_peering_peer_asn
}
