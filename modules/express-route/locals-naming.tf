locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  name_suffixes = compact([
    var.client_name,
    var.location_short,
    var.environment,
    local.name_suffix,
    var.name_slug,
  ])

  gateway_name = coalesce(var.gateway_custom_name, data.azurecaf_name.gateway.result)
  circuit_name = coalesce(var.circuit_custom_name, data.azurecaf_name.circuit.result)
}
