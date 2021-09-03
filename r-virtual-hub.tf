resource "azurerm_virtual_hub" "vhub" {
  name                = local.vhub_name
  location            = var.location
  resource_group_name = var.resource_group_name

  virtual_wan_id = azurerm_virtual_wan.vwan.id
  address_prefix = var.vhub_address_prefix

  sku = var.vhub_sku

  dynamic "route" {
    for_each = toset(var.vhub_routes)
    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }

  tags = merge(local.tags, var.vhub_extra_tags)
}
