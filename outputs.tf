output "express_route_circuit_id" {
  description = "The ID of the ExpressRoute circuit"
  value       = one(module.express_route[*].express_route_circuit_id)
}

output "express_route_circuit_service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider"
  value       = one(module.express_route[*].express_route_circuit_service_provider_provisioning_state)
}

output "express_route_circuit_service_key" {
  description = "The string needed by the service provider to provision the ExpressRoute circuit"
  value       = one(module.express_route[*].express_route_circuit_service_key)
  sensitive   = true
}

output "express_route_gateway_id" {
  description = "ID of the ExpressRoute gateway"
  value       = one(module.express_route[*].express_route_gateway_id)
}

output "express_route_peering_azure_asn" {
  description = "ASN (Autonomous System Number) Used by Azure for BGP Peering"
  value       = one(module.express_route[*].express_route_peering_azure_asn)
}

output "firewall_public_ip" {
  description = "Public IP address of the Firewall"
  value       = one(module.firewall[*].firewall_public_ip)
}

output "firewall_id" {
  description = "ID of the firewall"
  value       = one(module.firewall[*].firewall_id)
}

output "firewall_private_ip_address" {
  description = "Private IP address of the firewall"
  value       = one(module.firewall[*].firewall_private_ip_address)
}

output "firewall_ip_configuration" {
  description = "IP configuration of the created firewall"
  value       = one(module.firewall[*].firewall_ip_configuration)
}

output "firewall_management_ip_configuration" {
  description = "Management IP configuration of the created firewall"
  value       = one(module.firewall[*].firewall_management_ip_configuration)
}

output "virtual_hub_id" {
  description = "ID of the virtual hub"
  value       = module.vhub.virtual_hub_id
}

output "virtual_hub_default_route_table_id" {
  description = "ID of the default route table in the Virtual Hub"
  value       = module.vhub.virtual_hub_default_route_table_id
}

output "virtual_wan_id" {
  description = "ID of the Virtual Wan"
  value       = azurerm_virtual_wan.vwan.id
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = one(module.vpn[*].vpn_gateway_id)
}

output "vpn_gateway_bgp_settings" {
  description = "BGP Settings of the VPN Gateway"
  value       = one(module.vpn[*].vpn_gateway_bgp_settings)
}

output "vpn_gateway_connections_ids" {
  description = "List of name and IDs of VPN gateway connections"
  value       = one(module.vpn[*].vpn_gateway_connection_ids)
}
