resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  name           = "hubRoutingIntent"
  virtual_hub_id = var.virtual_hub_id

  dynamic "routing_policy" {
    for_each = var.internet_routing_enabled ? ["internet_routing_enabled"] : null

    content {
      name         = "Internet"
      destinations = ["Internet"]
      next_hop     = var.next_hop_resource_id
    }
  }

  dynamic "routing_policy" {
    for_each = var.private_routing_enabled ? ["private_routing_enabled"] : null

    content {
      name         = "PrivateTraffic"
      destinations = ["PrivateTraffic"]
      next_hop     = var.next_hop_resource_id
    }
  }
}
