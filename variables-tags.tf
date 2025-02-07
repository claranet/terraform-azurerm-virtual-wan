variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
  nullable    = false
}

variable "extra_tags" {
  description = "Map of additional tags."
  type        = map(string)
  default     = null
}

variable "virtual_wan_extra_tags" {
  description = "Extra tags for this Virtual WAN."
  type        = map(string)
  default     = null
}

variable "virtual_hub_extra_tags" {
  description = "Extra tags for the Virtual Hub."
  type        = map(string)
  default     = null
}

variable "express_route_extra_tags" {
  description = "Extra tags for the Express Route."
  type        = map(string)
  default     = null
}

variable "firewall_extra_tags" {
  description = "Extra tags for the firewall."
  type        = map(string)
  default     = null
}

variable "vpn_gateway_extra_tags" {
  description = "Extra tags for the VPN gateway."
  type        = map(string)
  default     = null
}
