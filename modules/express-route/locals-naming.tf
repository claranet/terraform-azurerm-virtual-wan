locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  ergw_name   = coalesce(var.custom_express_route_gateway_name, data.azurecaf_name.azure_express_route_gateway_caf.result)
  erc_name    = coalesce(var.custom_express_route_circuit_name, data.azurecaf_name.azure_express_route_circuit_caf.result)
}
