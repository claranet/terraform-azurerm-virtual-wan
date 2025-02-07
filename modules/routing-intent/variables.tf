variable "virtual_hub" {
  description = "ID of the Virtual Hub in which to enable the routing intent feature."
  type = object({
    id = string
  })
  nullable = false
}

variable "internet_routing_enabled" {
  description = "Whether or not to enable internet routing through the next hop."
  type        = bool
  default     = true
  nullable    = false
}

variable "private_routing_enabled" {
  description = "Whether or not to enable private routing through the next hop."
  type        = bool
  default     = true
  nullable    = false
}

variable "next_hop_resource_id" {
  description = "Resource ID of the next hop (e.g. Azure Firewall, NVA, etc.)."
  type        = string
  nullable    = false
}
