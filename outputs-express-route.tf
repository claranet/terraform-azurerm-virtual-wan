output "module_express_route" {
  description = "Express Route module outputs."
  value       = one(module.express_route[*])
}

output "express_route_gateway_id" {
  description = "ID of the Express Route gateway."
  value       = one(module.express_route[*].gateway_id)
}

output "express_route_gateway_name" {
  description = "Name of the Express Route gateway."
  value       = one(module.express_route[*].gateway_name)
}

output "express_route_circuit_id" {
  description = "ID of the Express Route circuit."
  value       = one(module.express_route[*].circuit_id)
}

output "express_route_circuit_name" {
  description = "Name of the Express Route circuit."
  value       = one(module.express_route[*].circuit_name)
}

output "express_route_circuit_service_provider_provisioning_state" {
  description = "The Express Route circuit provisioning state from your chosen service provider."
  value       = one(module.express_route[*].circuit_service_provider_provisioning_state)
}

output "express_route_circuit_service_key" {
  description = "The string needed by the service provider to provision the Express Route circuit."
  value       = one(module.express_route[*].circuit_service_key)
  sensitive   = true
}

output "express_route_private_peering_azure_asn" {
  description = "Autonomous System Number used by Azure for BGP peering."
  value       = one(module.express_route[*].private_peering_azure_asn)
}
