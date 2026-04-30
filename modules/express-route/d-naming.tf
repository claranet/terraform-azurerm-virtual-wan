data "azurecaf_name" "gateway" {
  name          = var.stack
  resource_type = "azurerm_express_route_gateway"
  prefixes      = var.name_prefix == "" ? null : local.name_prefix[*]
  suffixes      = local.name_suffixes
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "circuit" {
  name          = var.stack
  resource_type = "azurerm_express_route_circuit"
  prefixes      = var.name_prefix == "" ? null : local.name_prefix[*]
  suffixes      = local.name_suffixes
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "connection" {
  name        = var.stack
  prefixes    = compact([local.name_prefix, "ercn"])
  suffixes    = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug    = false
  clean_input = true
  separator   = "-"
}
