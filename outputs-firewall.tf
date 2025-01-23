output "module_firewall" {
  description = "Firewall module outputs."
  value       = one(module.firewall[*])
}

output "firewall_id" {
  description = "ID of the firewall."
  value       = one(module.firewall[*].id)
}

output "firewall_name" {
  description = "Name of the firewall."
  value       = one(module.firewall[*].name)
}

output "firewall_ip_configuration" {
  description = "IP configuration of the firewall."
  value       = one(module.firewall[*].ip_configuration)
}

output "firewall_management_ip_configuration" {
  description = "Management IP configuration of the firewall."
  value       = one(module.firewall[*].management_ip_configuration)
}

output "firewall_public_ip_addresses" {
  description = "Public IP addresses of the firewall."
  value       = one(module.firewall[*].public_ip_addresses)
}

output "firewall_private_ip_address" {
  description = "Private IP address of the firewall."
  value       = one(module.firewall[*].private_ip_address)
}
