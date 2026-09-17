output "module_virtual_hub" {
  description = "Virtual Hub module outputs. `null` when `var.virtual_hub_enabled` is `false`."
  value       = one(module.virtual_hub[*])
}

output "virtual_hub_id" {
  description = "ID of the Virtual Hub. `null` when `var.virtual_hub_enabled` is `false`."
  value       = one(module.virtual_hub[*].id)
}

output "virtual_hub_name" {
  description = "Name of the Virtual Hub. `null` when `var.virtual_hub_enabled` is `false`."
  value       = one(module.virtual_hub[*].name)
}

output "virtual_hub_default_route_table_id" {
  description = "ID of the default route table associated with the Virtual Hub. `null` when `var.virtual_hub_enabled` is `false`."
  value       = one(module.virtual_hub[*].default_route_table_id)
}
