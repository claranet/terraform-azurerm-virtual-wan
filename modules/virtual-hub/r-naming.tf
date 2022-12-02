data "azurecaf_name" "virtual_hub" {
  name          = var.stack
  resource_type = "azurerm_virtual_hub"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, local.name_slug])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
