locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  vwan_name = coalesce(var.custom_vwan_name, data.azurecaf_name.virtual_wan_caf.result)
}
