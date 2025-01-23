output "resource" {
  description = "VPN gateway resource object."
  value       = azurerm_vpn_gateway.main
}

output "resource_vpn_site" {
  description = "VPN site resource object."
  value       = azurerm_vpn_site.main
}

output "resource_vpn_connection" {
  description = "VPN connection resource object."
  value       = azurerm_vpn_gateway_connection.main
}

output "id" {
  description = "ID of the VPN gateway."
  value       = azurerm_vpn_gateway.main.id
}

output "name" {
  description = "Name of the VPN gateway."
  value       = azurerm_vpn_gateway.main.name
}

output "bgp_settings" {
  description = "BGP settings of the VPN gateway."
  value       = azurerm_vpn_gateway.main.bgp_settings
}

output "vpn_connections_ids" {
  description = "Map of VPN gateway connections (name => ID)."
  value       = local.vpn_connections_ids
}
