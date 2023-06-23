resource "azapi_resource" "routing_intent" {
  name      = "hubRoutingIntent"
  parent_id = var.virtual_hub_id
  type      = "Microsoft.Network/virtualHubs/routingIntent@2022-11-01"

  body = jsonencode({
    properties = {
      routingPolicies = local.routing_policies
    }

  })
}
