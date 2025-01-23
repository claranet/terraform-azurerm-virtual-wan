module "firewall" {
  source = "./modules/firewall"

  count = var.firewall_enabled ? 1 : 0

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix
  name_slug   = var.name_slug

  custom_name                     = var.firewall_custom_name
  diagnostic_settings_custom_name = var.firewall_diagnostic_settings_custom_name

  virtual_hub = module.virtual_hub

  public_ip_count   = var.firewall_public_ip_count
  firewall_policy   = var.firewall_policy
  sku_tier          = var.firewall_sku_tier
  dns_servers       = var.firewall_dns_servers
  private_ip_ranges = var.firewall_private_ip_ranges

  logs_destinations_ids   = coalesce(var.firewall_logs_destinations_ids, var.logs_destinations_ids)
  logs_categories         = var.firewall_logs_categories
  logs_metrics_categories = var.firewall_logs_metrics_categories

  zones = var.firewall_zones

  extra_tags = merge(local.tags, var.firewall_extra_tags)
}

moved {
  from = module.firewall["firewall"]
  to   = module.firewall[0]
}
