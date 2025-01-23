resource "azurerm_virtual_wan" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  type = var.type

  disable_vpn_encryption            = !var.vpn_encryption_enabled
  allow_branch_to_branch_traffic    = var.branch_to_branch_traffic_allowed
  office365_local_breakout_category = var.office365_local_breakout_category

  tags = merge(local.tags, var.virtual_wan_extra_tags)
}

moved {
  from = azurerm_virtual_wan.vwan
  to   = azurerm_virtual_wan.main
}
