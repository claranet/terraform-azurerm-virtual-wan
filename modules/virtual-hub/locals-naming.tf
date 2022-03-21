locals {
  name_prefix       = lower(var.name_prefix)
  name_suffix       = lower(var.name_suffix)
  default_naming    = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  default_vhub_name = "vhub-${local.default_naming}"

  vhub_name = coalesce(var.custom_virtual_hub_name, local.default_vhub_name)
}
