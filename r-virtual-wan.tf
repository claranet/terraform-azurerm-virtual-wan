resource "azurerm_virtual_wan" "vwan" {
  location            = var.location
  name                = local.vwan_name
  resource_group_name = var.resource_group_name

  disable_vpn_encryption            = var.vpn_encryption_enabled ? false : true
  allow_branch_to_branch_traffic    = var.branch_to_branch_traffic_allowed
  office365_local_breakout_category = var.office365_local_breakout_category

  type = var.virtual_wan_type

  tags = merge(local.tags, var.virtual_wan_extra_tags)
}
