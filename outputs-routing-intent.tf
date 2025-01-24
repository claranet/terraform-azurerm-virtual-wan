output "module_routing_intent" {
  description = "Routing intent module outputs."
  value       = one(module.routing_intent[*])
}

output "routing_intent_id" {
  description = "ID of the routing intent."
  value       = one(module.routing_intent[*].id)
}

output "routing_intent_name" {
  description = "Name of the routing intent."
  value       = one(module.routing_intent[*].name)
}
