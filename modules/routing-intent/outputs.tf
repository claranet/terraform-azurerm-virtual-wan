output "resource" {
  description = "Routing intent resource object."
  value       = azurerm_virtual_hub_routing_intent.main
}

output "id" {
  description = "ID of the routing intent."
  value       = azurerm_virtual_hub_routing_intent.main.id
}

output "name" {
  description = "Name of the routing intent."
  value       = azurerm_virtual_hub_routing_intent.main.name
}
