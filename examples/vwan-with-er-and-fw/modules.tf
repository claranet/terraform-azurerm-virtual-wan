module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "4.1.1"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "5.0.1"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "5.0.0"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  vhub_address_prefix = var.vhub_address_prefix

  enable_firewall           = true
  enable_express_route      = true
  enable_er_private_peering = true

  erc_service_provider  = var.erc_service_provider
  erc_peering_location  = var.erc_peering_location
  erc_bandwidth_in_mbps = var.erc_bandwidth_in_mbps

  erc_private_peering_primary_peer_address_prefix   = var.erc_private_peering_primary_peer_address_prefix
  erc_private_peering_secondary_peer_address_prefix = var.erc_private_peering_secondary_peer_address_prefix
  erc_private_peering_vlan_id                       = var.erc_private_peering_vlan_id
  erc_private_peering_peer_asn                      = var.erc_private_peering_peer_asn
  erc_private_peering_shared_key                    = var.erc_private_peering_shared_key

  logs_destinations_ids = [
    azurerm_log_analytics_workspace.logs.id
  ]
}
