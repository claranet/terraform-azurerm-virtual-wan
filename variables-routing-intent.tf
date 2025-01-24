variable "routing_intent_enabled" {
  description = "Enable or disable routing intent feature in the Virtual Hub."
  type        = bool
  default     = false
  nullable    = false
}

variable "internet_routing_enabled" {
  description = "Whether force the internet routing through Azure Firewall or the NVA."
  type        = bool
  default     = true
  nullable    = false
}

variable "private_routing_enabled" {
  description = "Whether force the private routing through Azure Firewall or the NVA."
  type        = bool
  default     = true
  nullable    = false
}

variable "azure_firewall_as_next_hop_enabled" {
  description = "Whether use Azure Firewall as next hop or a NVA."
  type        = bool
  default     = true
  nullable    = false
}

variable "next_hop_nva_id" {
  description = "ID of the NVA used as next hop."
  type        = string
  default     = null
}
