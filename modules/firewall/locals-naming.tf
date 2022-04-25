locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  fw_name     = coalesce(var.custom_firewall_name, azurecaf_name.azure_firewall_caf.result)
}
