output "resource" {
  description = "Virtual WAN resource object."
  value       = azurerm_virtual_wan.main
}

output "id" {
  description = "ID of the Virtual WAN."
  value       = azurerm_virtual_wan.main.id
}

output "name" {
  description = "Name of the Virtual WAN."
  value       = azurerm_virtual_wan.main.name
}
