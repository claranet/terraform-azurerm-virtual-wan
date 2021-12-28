data "azurerm_resources" "resources" {
  resource_group_name = var.resource_group_name
}

module "diagnostics_settings" {
  for_each = {
    for r in data.azurerm_resources.resources.resources : r.id => r
    if length(regexall("virtualHubs|virtualWans|expressRouteGateways|firewallPolicies|workbooks|ipGroups", r.type)) == 0
  }

  source  = "claranet/diagnostic-settings/azurerm"
  version = "4.0.3"

  resource_id = each.value.id

  logs_destinations_ids          = var.logs_destinations_ids
  log_analytics_destination_type = "Dedicated"
}
