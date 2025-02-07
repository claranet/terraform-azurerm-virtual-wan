output "module_vpn" {
  description = "VPN module outputs."
  value       = one(module.vpn[*])
}

output "vpn_gateway_id" {
  description = "ID of the VPN gateway."
  value       = one(module.vpn[*].id)
}

output "vpn_gateway_name" {
  description = "Name of the VPN gateway."
  value       = one(module.vpn[*].name)
}

output "vpn_gateway_bgp_settings" {
  description = "BGP settings of the VPN gateway."
  value       = one(module.vpn[*].bgp_settings)
}

output "vpn_gateway_connections_ids" {
  description = "Map of VPN gateway connections (name => ID)."
  value       = one(module.vpn[*].vpn_connections_ids)
}
