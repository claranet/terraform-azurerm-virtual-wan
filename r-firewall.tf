module "firewall" {
  for_each = var.firewall_enabled ? toset(["firewall"]) : toset([])
  source   = "./modules/firewall"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
  custom_name = var.custom_firewall_name

  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_slug   = var.name_slug
  name_suffix = var.name_suffix

  logs_destinations_ids = var.logs_destinations_ids

  virtual_hub_id = module.vhub.virtual_hub_id

  firewall_sku_tier  = var.firewall_sku_tier
  firewall_policy_id = var.firewall_policy_id

  firewall_public_ip_count    = var.firewall_public_ip_count
  firewall_availibility_zones = var.firewall_availibility_zones
  firewall_dns_servers        = var.firewall_dns_servers
  firewall_private_ip_ranges  = var.firewall_private_ip_ranges
  threat_intel_mode           = var.firewall_threat_intel_mode

  extra_tags = merge(local.tags, var.firewall_extra_tags)
}
