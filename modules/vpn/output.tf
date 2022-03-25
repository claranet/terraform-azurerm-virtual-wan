output "vpn_gateway_id" {
  description = "Id of the created vpn gateway"
  value       = azurerm_vpn_gateway.vpn.id
}

output "vpn_gateway_bgp_settings" {
  description = "BGP Settings of the VPN Gateway"
  value       = azurerm_vpn_gateway.vpn.bgp_settings
}

output "vpn_gateway_connection_ids" {
  description = "List of name and ids of vpn gateway connections"
  value = [for conn in azurerm_vpn_gateway_connection.vpn_gateway_connection : {
    name          = conn.name
    connection_id = conn.id
  }]
}
