locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  name_slug   = lower(var.name_slug)

  default_naming    = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}${local.name_suffix}${local.name_slug}"
  default_vhub_name = "vhub-${local.default_naming}"

  vhub_name = coalesce(var.custom_virtual_hub_name, local.default_vhub_name)
}
