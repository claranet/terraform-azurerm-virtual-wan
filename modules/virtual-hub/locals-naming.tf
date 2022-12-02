locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  name_slug   = lower(var.name_slug)

  vhub_name = coalesce(var.custom_virtual_hub_name, data.azurecaf_name.virtual_hub.result)
}
