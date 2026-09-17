locals {
  # Settings that cannot work without a Virtual Hub.
  virtual_hub_dependents = compact([
    var.vpn_gateway_enabled ? "var.vpn_gateway_enabled" : "",
    var.express_route_enabled ? "var.express_route_enabled" : "",
    var.firewall_enabled ? "var.firewall_enabled" : "",
    var.routing_intent_enabled ? "var.routing_intent_enabled" : "",
    length(var.peered_virtual_networks) > 0 ? "var.peered_virtual_networks" : "",
    length(var.virtual_hub_routes) > 0 ? "var.virtual_hub_routes" : "",
  ])
}

resource "terraform_data" "virtual_hub_precondition" {
  triggers_replace = [var.virtual_hub_enabled]

  lifecycle {
    precondition {
      condition     = var.virtual_hub_enabled || length(local.virtual_hub_dependents) == 0
      error_message = "The Virtual Hub is required by ${join(", ", local.virtual_hub_dependents)}. Set `var.virtual_hub_enabled` to `true`, or disable them."
    }
  }
}
