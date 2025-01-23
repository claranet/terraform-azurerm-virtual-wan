resource "terraform_data" "routing_precondition" {
  count = var.routing_intent_enabled ? 1 : 0

  triggers_replace = [
    var.azure_firewall_as_next_hop_enabled,
    var.next_hop_nva_id
  ]

  lifecycle {
    precondition {
      condition     = var.azure_firewall_as_next_hop_enabled ? var.next_hop_nva_id == null : var.next_hop_nva_id != null
      error_message = "The variable 'next_hop_nva_id' must be null if 'azure_firewall_as_next_hop_enabled' is true or must not be empty if 'azure_firewall_as_next_hop_enabled' is false."
    }
  }
}

module "routing" {
  source = "./modules/routing-intent"

  count = length(terraform_data.routing_precondition)

  virtual_hub = module.virtual_hub

  internet_routing_enabled = var.internet_routing_enabled
  private_routing_enabled  = var.private_routing_enabled

  next_hop_resource_id = var.azure_firewall_as_next_hop_enabled ? one(module.firewall[*].id) : var.next_hop_nva_id
}
