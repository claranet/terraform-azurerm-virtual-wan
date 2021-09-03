resource "azurecaf_name" "caf" {
  for_each      = toset(local.caf_naming_resources)
  name          = var.stack
  resource_type = each.value
  prefixes      = var.name_prefix == "" ? null : [var.name_prefix]
  suffixes      = compact([var.client_name, var.environment, local.name_suffix, var.use_caf_naming ? "" : local.clara_slug])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

