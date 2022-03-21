resource "azurecaf_name" "azure_firewall_caf" {
  name          = var.stack
  resource_type = "azurerm_firewall"
  prefixes      = var.name_prefix == "" ? null : [var.name_prefix]
  suffixes      = compact([var.client_name, var.environment, var.location_short, local.name_suffix, var.name_slug])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
