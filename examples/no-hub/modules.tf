module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  # Only the Virtual WAN is managed, no Virtual Hub is created.
  virtual_hub_enabled = false

  # Every Virtual Hub feature must stay disabled accordingly, `firewall_enabled`
  # defaults to `true`.
  firewall_enabled = false

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]
}
