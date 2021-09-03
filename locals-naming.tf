locals {
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  caf_naming_resources = [
    "azurerm_virtual_wan",
    "azurerm_express_route_gateway",
    "azurerm_express_route_circuit",
    "azurerm_firewall",
    "azurerm_public_ip",
    "azurerm_firewall_ip_configuration"
  ]

  vwan_name = coalesce(var.custom_vwan_name, azurecaf_name.caf["azurerm_virtual_wan"].result)
  ergw_name = coalesce(var.custom_ergw_name, azurecaf_name.caf["azurerm_express_route_gateway"].result)
  erc_name  = coalesce(var.custom_erc_name, azurecaf_name.caf["azurerm_express_route_circuit"].result)
  fw_name   = coalesce(var.custom_fw_name, azurecaf_name.caf["azurerm_firewall"].result)

  default_naming    = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  default_vhub_name = "${local.default_naming}-vhub"

  vhub_name = coalesce(var.custom_vhub_name, local.default_vhub_name)
}
