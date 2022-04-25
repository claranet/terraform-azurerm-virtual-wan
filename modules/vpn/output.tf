output "vpn_gateway_id" {
  description = "ID of the created VPN gateway"
  value       = azurerm_vpn_gateway.vpn.id
}

output "vpn_gateway_bgp_settings" {
  description = "BGP settings of the VPN Gateway"
  value       = azurerm_vpn_gateway.vpn.bgp_settings
}

output "vpn_gateway_connection_ids" {
  description = "List of name and IDs of VPN gateway connections"
  value = [for conn in azurerm_vpn_gateway_connection.vpn_gateway_connection : {
    name          = conn.name
    connection_id = conn.id
  }]
}
