locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  vwan_name         = coalesce(var.custom_vwan_name, azurecaf_name.virtual_wan_caf.result)
  default_naming    = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  default_vhub_name = "${local.default_naming}-vhub"

}
