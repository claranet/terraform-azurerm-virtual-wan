output "resource" {
  description = "Virtual Hub resource object."
  value       = azurerm_virtual_hub.main
}

output "resource_virtual_hub_connection" {
  description = "Virtual Hub connection resource object."
  value       = azurerm_virtual_hub_connection.main
}

output "id" {
  description = "ID of the Virtual Hub."
  value       = azurerm_virtual_hub.main.id
}

output "name" {
  description = "Name of the Virtual Hub."
  value       = azurerm_virtual_hub.main.name
}

output "default_route_table_id" {
  description = "ID of the default route table associated with the Virtual Hub."
  value       = azurerm_virtual_hub.main.default_route_table_id
}
