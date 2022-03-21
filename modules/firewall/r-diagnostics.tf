module "firewall_diagnostic_settings" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "5.0.0"

  logs_destinations_ids = var.logs_destinations_ids
  resource_id           = azurerm_firewall.azfw.id
}
