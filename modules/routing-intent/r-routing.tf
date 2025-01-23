resource "azurerm_virtual_hub_routing_intent" "main" {
  name = "hubRoutingIntent"

  virtual_hub_id = var.virtual_hub.id

  dynamic "routing_policy" {
    for_each = var.internet_routing_enabled ? [0] : null
    content {
      name         = "Internet"
      destinations = ["Internet"]
      next_hop     = var.next_hop_resource_id
    }
  }

  dynamic "routing_policy" {
    for_each = var.private_routing_enabled ? [0] : null
    content {
      name         = "PrivateTraffic"
      destinations = ["PrivateTraffic"]
      next_hop     = var.next_hop_resource_id
    }
  }
}

moved {
  from = azurerm_virtual_hub_routing_intent.routing_intent
  to   = azurerm_virtual_hub_routing_intent.main
}
