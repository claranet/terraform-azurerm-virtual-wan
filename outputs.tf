output "express_route_circuit_id" {
  description = "The ID of the ExpressRoute circuit"
  value       = try(module.express_route["express_route"].express_route_circuit_id, null)
}

output "express_route_circuit_service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider"
  value       = try(module.express_route["express_route"].express_route_circuit_service_provider_provisioning_state, null)
}

output "express_route_circuit_service_key" {
  description = "The string needed by the service provider to provision the ExressRoute circuit"
  value       = try(module.express_route["express_route"].express_route_circuit_service_key, null)
  sensitive   = true
}

output "express_route_gateway_id" {
  description = "Id of the ExpressRoute gateway"
  value       = try(module.express_route["express_route"].express_route_gateway_id, null)
}

output "express_route_peering_azure_asn" {
  description = "ASN (Autonomous System Number) Used by Azure for BGP Peering"
  value       = try(module.express_route["express_route"].express_route_peering_azure_asn, null)
}

output "firewall_public_ip" {
  description = "Public IP address of the Firewall"
  value       = try(module.firewall.firewall_public_ip, null)
}

output "firewall_id" {
  description = "Id of the firewall"
  value       = try(module.firewall.firewall_id, null)
}

output "firewall_private_ip_address" {
  description = "Private IP address of the firewall"
  value       = try(module.firewall.firewall_private_ip_address, null)
}

output "virtual_hub_id" {
  description = "Id of the virtual hub"
  value       = module.vhub.virtual_hub_id
}

output "virtual_wan_id" {
  description = "Id of the Virtual Wan"
  value       = azurerm_virtual_wan.vwan.id
}
