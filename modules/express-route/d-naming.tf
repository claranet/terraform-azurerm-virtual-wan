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
