resource "azurerm_virtual_hub_routing_intent" "main" {
  name = coalesce(var.custom_name, "hubRoutingIntent")

  virtual_hub_id = var.virtual_hub.id

  dynamic "routing_policy" {
    for_each = var.internet_routing_enabled ? [0] : []
    content {
      name         = "Internet"
      destinations = ["Internet"]
      next_hop     = var.next_hop_resource_id
    }
  }

  dynamic "routing_policy" {
    for_each = var.private_routing_enabled ? [0] : []
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
