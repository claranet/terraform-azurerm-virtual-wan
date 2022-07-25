output "express_route_circuit_id" {
  description = "The ID of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.erc.id
}

output "express_route_circuit_service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider"
  value       = try(azurerm_express_route_circuit.erc.service_provider_provisioning_state, null)
}

output "express_route_circuit_service_key" {
  description = "The string needed by the service provider to provision the ExpressRoute circuit"
  value       = try(azurerm_express_route_circuit.erc.service_key, null)
  sensitive   = true
}

output "express_route_gateway_id" {
  description = "ID of the ExpressRoute gateway"
  value       = azurerm_express_route_gateway.ergw.id
}

output "express_route_peering_azure_asn" {
  description = "ASN (Autonomous System Number) Used by Azure for BGP Peering"
  value       = try(azurerm_express_route_circuit_peering.ercprivatepeer["express_route"].azure_asn, null)
}
