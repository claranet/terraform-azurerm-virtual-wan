module "circuit_diagnostic_settings" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.0.0"

  custom_name = var.diagnostic_settings_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  resource_id = azurerm_express_route_circuit.main.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
}

moved {
  from = module.express_route_circuit_diagnostic_settings
  to   = module.circuit_diagnostic_settings
}
