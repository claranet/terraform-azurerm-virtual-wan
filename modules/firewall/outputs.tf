output "firewall_id" {
  description = "ID of the created firewall"
  value       = azurerm_firewall.azfw.id
}

output "firewall_ip_configuration" {
  description = "IP configuration of the created firewall"
  value       = azurerm_firewall.azfw.ip_configuration
}

output "firewall_management_ip_configuration" {
  description = "Management IP configuration of the created firewall"
  value       = azurerm_firewall.azfw.management_ip_configuration
}

output "firewall_public_ip" {
  description = "Public IP address of the firewall"
  value       = azurerm_firewall.azfw.virtual_hub[0].public_ip_addresses
}

output "firewall_private_ip_address" {
  description = "Private IP address of the firewall"
  value       = azurerm_firewall.azfw.virtual_hub[0].private_ip_address
}
