resource "azurerm_virtual_wan" "vwan" {
  location            = var.location
  name                = local.vwan_name
  resource_group_name = var.resource_group_name

  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category

  type = var.vwan_type

  tags = merge(local.tags, var.vwan_extra_tags)
}
