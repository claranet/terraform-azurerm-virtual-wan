data "azurecaf_name" "main" {
  name          = var.stack
  resource_type = "azurerm_point_to_site_vpn_gateway"
  prefixes      = var.name_prefix == "" ? null : local.name_prefix[*]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.name_slug])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
