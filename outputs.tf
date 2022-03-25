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

output "firewall_ip_configuration" {
  description = "IP configuration of the created firewall"
  value       = module.firewall.firewall_ip_configuration
}

output "firewall_management_ip_configuration" {
  description = "Management IP configuration of the created firewall"
  value       = module.firewall.firewall_management_ip_configuration
}

output "virtual_hub_id" {
  description = "Id of the virtual hub"
  value       = module.vhub.virtual_hub_id
}

output "virtual_hub_default_route_table_id" {
  description = "Id of the default route table in the Virtual Hub"
  value       = module.vhub.virtual_hub_default_route_table_id
}

output "virtual_wan_id" {
  description = "Id of the Virtual Wan"
  value       = azurerm_virtual_wan.vwan.id
}

output "vpn_gateway_id" {
  description = "Id of the VPN Gateway"
  value       = module.vpn.vpn_gateway_id
}

output "vpn_gateway_bgp_settings" {
  description = "BGP Settings of the VPN Gateway"
  value       = module.vpn.vpn_gateway_bgp_settings
}

output "vpn_gateway_connections_ids" {
  description = "List of name and ids of vpn gateway connections"
  value       = module.vpn.vpn_gateway_connection_ids
}
