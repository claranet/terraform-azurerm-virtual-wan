module "express_route_circuit_diagnostic_settings" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "6.2.0"

  resource_id           = azurerm_express_route_circuit.erc.id
  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.logs_retention_days

  use_caf_naming = true
  custom_name    = var.custom_diagnostic_settings_name
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
}
