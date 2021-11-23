output "express_route_circuit_id" {
  description = "The ID of the ExpressRoute circuit"
  value       = azurerm_express_route_circuit.erc["express_route"].id
}

output "express_route_circuit_service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider"
  value       = azurerm_express_route_circuit.erc["express_route"].service_provider_provisioning_state
}

output "express_route_circuit_service_key" {
  description = "The string needed by the service provider to provision the ExressRoute circuit"
  value       = azurerm_express_route_circuit.erc["express_route"].service_key
  sensitive   = true
}

output "express_route_gateway_id" {
  description = "Id of the ExpressRoute gateway"
  value       = azurerm_express_route_gateway.ergw["express_route"].id
}

output "express_route_peering_azure_asn" {
  description = "ASN (Autonomous System Number) Used by Azure for BGP Peering"
  value       = azurerm_express_route_circuit_peering.ercprivatepeer["express_route"].azure_asn
}

output "firewall_public_ip" {
  description = "Public IP address of the Firewall"
  value       = azurerm_firewall.azfw["firewall"].virtual_hub[0].public_ip_addresses
}

output "firewall_id" {
  description = "Id of the firewall"
  value       = azurerm_firewall.azfw["firewall"].id
}

output "firewall_private_ip_address" {
  description = "Private IP address of the firewall"
  value       = azurerm_firewall.azfw["firewall"].virtual_hub[0].private_ip_address
}

output "virtual_hub_id" {
  description = "Id of the virtual hub"
  value       = azurerm_virtual_hub.vhub.id
}
