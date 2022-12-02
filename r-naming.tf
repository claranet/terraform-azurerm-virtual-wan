data "azurecaf_name" "virtual_wan_caf" {
  name          = var.stack
  resource_type = "azurerm_virtual_wan"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.name_slug])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
