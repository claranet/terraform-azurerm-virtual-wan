resource "terraform_data" "routing_intent_precondition" {
  count = var.routing_intent_enabled ? 1 : 0

  triggers_replace = [
    var.azure_firewall_as_next_hop_enabled,
    var.next_hop_nva_id,
  ]

  lifecycle {
    precondition {
      condition     = var.azure_firewall_as_next_hop_enabled ? var.next_hop_nva_id == null : var.next_hop_nva_id != null
      error_message = "`var.next_hop_nva_id` must be `null` if `var.azure_firewall_as_next_hop_enabled = true` or must not be empty if `var.azure_firewall_as_next_hop_enabled = false`."
    }
  }
}

module "routing_intent" {
  source = "./modules/routing-intent"

  count = length(terraform_data.routing_intent_precondition)

  virtual_hub = module.virtual_hub

  custom_name = var.routing_intent_custom_name

  internet_routing_enabled = var.internet_routing_enabled
  private_routing_enabled  = var.private_routing_enabled

  next_hop_resource_id = var.azure_firewall_as_next_hop_enabled ? one(module.firewall[*].id) : var.next_hop_nva_id
}

moved {
  from = module.routing["enabled"]
  to   = module.routing_intent[0]
}
