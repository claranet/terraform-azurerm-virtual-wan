module "express_route_circuit_diagnostics" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "5.0.0"

  logs_destinations_ids = var.logs_destinations_ids
  resource_id           = azurerm_express_route_circuit.erc.id
}

