locals {
  routing_policy_internet = {
    name         = "Internet"
    destinations = ["Internet"]
    nextHop      = var.next_hop_resource_id
  }

  routing_policy_private = {
    name         = "PrivateTraffic"
    destinations = ["PrivateTraffic"]
    nextHop      = var.next_hop_resource_id
  }

  routing_policies = [for item in [
    var.internet_routing_enabled ? local.routing_policy_internet : null,
    var.private_routing_enabled ? local.routing_policy_private : null
  ] : item if item != null]
}
