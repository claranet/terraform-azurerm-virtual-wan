resource "azurecaf_name" "caf" {
  for_each      = toset(local.caf_naming_resources)
  name          = var.stack
  resource_type = each.value
  prefixes      = var.name_prefix == "" ? null : [var.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix, var.name_slug])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

