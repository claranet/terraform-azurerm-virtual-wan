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

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_virtual_hub_connection" "peer_vnets_to_hub" {
  for_each = var.peered_virtual_networks != null ? { for p in var.peered_virtual_networks : p.vnet_id => p } : {}

  remote_virtual_network_id = each.value.vnet_id
  virtual_hub_id            = azurerm_virtual_hub.vhub.id

  name                      = coalesce(each.value.peering_name, format("peer_%s_to_%s", split("/", each.value.vnet_id)[8], local.vhub_name))
  internet_security_enabled = coalesce(each.value.internet_security_enabled, var.internet_security_enabled)

  dynamic "routing" {
    for_each = each.value.routing != null ? ["enabled"] : []
    content {
      associated_route_table_id = each.value.routing.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = each.value.routing.propagated_route_table != null ? ["enabled"] : []
        content {
          labels          = each.value.routing.propagated_route_table.labels
          route_table_ids = each.value.routing.propagated_route_table.route_table_ids
        }
      }

      dynamic "static_vnet_route" {
        for_each = each.value.routing.static_vnet_route != null ? ["enabled"] : []
        content {
          name                = each.value.routing.static_vnet_route.name
          address_prefixes    = each.value.routing.static_vnet_route.address_prefixes
          next_hop_ip_address = each.value.routing.static_vnet_route.next_hop_ip_address
        }
      }
    }
  }
}
