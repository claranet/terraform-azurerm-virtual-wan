output "resource_gateway" {
  description = "Express Route gateway resource object."
  value       = azurerm_express_route_gateway.main
}

output "resource_circuit" {
  description = "Express Route circuit resource object."
  value       = azurerm_express_route_circuit.main
}

output "resource_circuit_peering" {
  description = "Express Route circuit peering resource object."
  value       = one(azurerm_express_route_circuit_peering.main[*])
}

output "gateway_id" {
  description = "The ID of the Express Route gateway."
  value       = azurerm_express_route_gateway.main.id
}

output "gateway_name" {
  description = "The name of the Express Route gateway."
  value       = azurerm_express_route_gateway.main.name
}

output "circuit_id" {
  description = "The ID of the Express Route circuit."
  value       = azurerm_express_route_circuit.main.id
}

output "circuit_name" {
  description = "The name of the Express Route circuit."
  value       = azurerm_express_route_circuit.main.name
}

output "circuit_service_provider_provisioning_state" {
  description = "The Express Route circuit provisioning state from your chosen service provider."
  value       = azurerm_express_route_circuit.main.service_provider_provisioning_state
}

output "circuit_service_key" {
  description = "The string needed by the service provider to provision the Express Route circuit."
  value       = azurerm_express_route_circuit.main.service_key
  sensitive   = true
}

output "private_peering_azure_asn" {
  description = "Autonomous System Number used by Azure for BGP peering."
  value       = one(azurerm_express_route_circuit_peering.main[*].azure_asn)
}
