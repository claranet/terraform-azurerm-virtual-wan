output "resource" {
  description = "Firewall resource object."
  value       = azurerm_firewall.main
}

output "module_diagnostic_settings" {
  description = "Diagnostic settings module output."
  value       = module.diagnostic_settings
}

output "id" {
  description = "ID of the firewall."
  value       = azurerm_firewall.main.id
}

output "name" {
  description = "Name of the firewall."
  value       = azurerm_firewall.main.name
}

output "ip_configuration" {
  description = "IP configuration of the firewall."
  value       = azurerm_firewall.main.ip_configuration
}

output "management_ip_configuration" {
  description = "Management IP configuration of the firewall."
  value       = azurerm_firewall.main.management_ip_configuration
}

output "public_ip_addresses" {
  description = "Public IP addresses of the firewall."
  value       = azurerm_firewall.main.virtual_hub[0].public_ip_addresses
}

output "private_ip_address" {
  description = "Private IP address of the firewall."
  value       = azurerm_firewall.main.virtual_hub[0].private_ip_address
}
