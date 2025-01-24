module "express_route" {
  source  = "claranet/virtual-wan/azurerm//modules/express-route"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_hub = module.virtual_hub

  circuit_peering_location  = "Paris"
  circuit_bandwidth_in_mbps = 100
  circuit_service_provider  = "Equinix"

  private_peering_enabled                       = true
  private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  private_peering_shared_key                    = "MySuperSecretSharedKey"
  private_peering_peer_asn                      = 4321
  private_peering_vlan_id                       = 1234

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]

  extra_tags = var.extra_tags
}
