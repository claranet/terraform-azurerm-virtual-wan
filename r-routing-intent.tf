module "routing" {
  for_each = var.routing_intent_enabled ? toset(["enabled"]) : toset([])
  source   = "./modules/routing-intent"

  next_hop_resource_id = var.azure_firewall_as_next_hop_enabled ? module.firewall["firewall"].firewall_id : var.next_hop_nva_id
  virtual_hub_id       = module.vhub.virtual_hub_id

  internet_routing_enabled = var.internet_routing_enabled
  private_routing_enabled  = var.private_routing_enabled
  depends_on               = [null_resource.routing_precondition]
}

resource "null_resource" "routing_precondition" {
  for_each = toset(var.routing_intent_enabled ? ["enabled"] : [])
  triggers = {
    azfw_next_hop = var.azure_firewall_as_next_hop_enabled
    nexhop_nva_id = var.next_hop_nva_id
  }
  lifecycle {
    precondition {
      condition     = var.azure_firewall_as_next_hop_enabled ? var.next_hop_nva_id == null : var.next_hop_nva_id != null
      error_message = "The variable 'next_hop_nva_id' must be null if 'azure_firewall_as_next_hop_enabled' is true or must not be empty if 'azure_firewall_as_next_hop_enabled' is false."
    }
  }
}
