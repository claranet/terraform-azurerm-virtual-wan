resource "azurerm_virtual_hub" "vhub" {
  name                = local.vhub_name
  location            = var.location
  resource_group_name = var.resource_group_name

  virtual_wan_id = var.virtual_wan_id
  address_prefix = var.virtual_hub_address_prefix

  sku = var.virtual_hub_sku

  dynamic "route" {
    for_each = toset(var.virtual_hub_routes)
    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }

  tags = merge(local.default_tags, var.virtual_hub_tags)
}

resource "azurerm_virtual_hub_connection" "peer_vnets_to_hub" {
  for_each                  = toset(var.peered_virtual_networks)
  name                      = "peer_${split("/", each.value)[8]}_to_${local.vhub_name}"
  remote_virtual_network_id = each.value
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
}
