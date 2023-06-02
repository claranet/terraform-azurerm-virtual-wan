variable "routing_intent_enabled" {
  description = "Whether enable or not the routing intent."
  type        = bool
  default     = false
}

variable "azure_firewall_as_next_hop_enabled" {
  description = "Whether use Azure Firewall as Next Hop or a NVA."
  type        = bool
  default     = true
}

variable "nexthop_nva_id" {
  description = "ID of the NVA used as Next Hop."
  type        = string
  default     = null
}

variable "internet_routing_enabled" {
  description = "Whether force the internet routing through Azure Firewall or the NVA."
  type        = bool
  default     = true
  nullable    = false
}

variable "private_routing_enabled" {
  description = "Whether force the internet routing through Azure Firewall or the NVA."
  type        = bool
  default     = true
  nullable    = false
}
