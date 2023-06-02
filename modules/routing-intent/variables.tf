variable "next_hop_resource_id" {
  description = "Resource ID of the next_hop (eg. Azure Firewall, NVA...)."
  type        = string
}

variable "virtual_hub_id" {
  description = "Virtual Hub ID to apply the routing intent."
  type        = string
}

variable "internet_routing_enabled" {
  description = "Whether enable internet routing through this next_hop."
  type        = bool
  default     = true
}
variable "private_routing_enabled" {
  description = "Whether enable private routing through this next_hop."
  type        = bool
  default     = true
}
