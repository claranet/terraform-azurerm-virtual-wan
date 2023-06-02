module "routing" {
  for_each = var.routing_intent_enabled ? toset(["enabled"]) : toset([])
  source   = "./modules/routing-intent"

  next_hop_resource_id = var.azure_firewall_as_next_hop_enabled ? module.firewall["firewall"].firewall_id : var.nexthop_nva_id
  virtual_hub_id       = module.vhub.virtual_hub_id

  internet_routing_enabled = var.internet_routing_enabled
  private_routing_enabled  = var.private_routing_enabled
}

resource "null_resource" "routing_precondition" {
  for_each = var.routing_intent_enabled ? toset(["enabled"]) : toset([])
  triggers = {
    azfw_nexthop  = var.azure_firewall_as_next_hop_enabled
    nexhop_nva_id = var.nexthop_nva_id
  }
  lifecycle {
    precondition {
      condition     = ((var.azure_firewall_as_next_hop_enabled && var.nexthop_nva_id == null) || (!var.azure_firewall_as_next_hop_enabled && var.nexthop_nva_id != null))
      error_message = "The varialbe nexthop_nva_id must be null if azure_firewall_as_next_hop_enabled is true or must not be emtpy if azure_firewall_as_next_hop_enabled is false."
    }
  }
}
