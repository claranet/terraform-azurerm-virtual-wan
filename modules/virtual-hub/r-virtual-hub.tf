resource "azurerm_virtual_hub" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  virtual_wan_id = var.virtual_wan.id

  sku            = var.sku
  address_prefix = var.address_prefix

  dynamic "route" {
    for_each = var.routes
    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_virtual_hub.vhub
  to   = azurerm_virtual_hub.main
}

resource "azurerm_virtual_hub_connection" "main" {
  for_each = local.peered_virtual_networks

  name = coalesce(each.value.peering_name, format("peer_%s_to_%s", reverse(split("/", each.key))[0], local.name))

  virtual_hub_id = azurerm_virtual_hub.main.id

  remote_virtual_network_id = each.key

  internet_security_enabled = coalesce(each.value.internet_security_enabled, var.internet_security_enabled)

  dynamic "routing" {
    for_each = each.value.routing[*]
    content {
      associated_route_table_id = routing.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table[*]
        content {
          labels          = propagated_route_table.value.labels
          route_table_ids = propagated_route_table.value.route_table_ids
        }
      }

      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route[*]
        content {
          name                = static_vnet_route.value.name
          address_prefixes    = static_vnet_route.value.address_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
        }
      }
    }
  }
}

moved {
  from = azurerm_virtual_hub_connection.peer_vnets_to_hub
  to   = azurerm_virtual_hub_connection.main
}
