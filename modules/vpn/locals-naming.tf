locals {
  name_prefix              = lower(var.name_prefix)
  name_suffix              = lower(var.name_suffix)
  default_naming           = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  default_vpn_gateway_name = "vpngw-${local.default_naming}"

  vpn_gateway_name            = coalesce(var.custom_vpn_gateway_name, local.default_vpn_gateway_name)
  vpn_gateway_connection_name = coalesce(var.custom_vpn_gateway_connection_name, format("%s-conn", local.vpn_gateway_name))
}
