variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Map of additional tags."
  type        = map(string)
  default     = {}
}

variable "virtual_wan_extra_tags" {
  description = "Extra tags for this Virtual Wan"
  type        = map(string)
  default     = {}
}


variable "virtual_hub_extra_tags" {
  description = "Extra tags for this Virtual Hub"
  type        = map(string)
  default     = {}
}

variable "express_route_gateway_extra_tags" {
  description = "Extra tags for Express Route Gateway"
  type        = map(string)
  default     = {}
}

variable "firewall_extra_tags" {
  description = "Extra tags for Firewall resource"
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_extra_tags" {
  description = "Extra tags for the VPN Gateway"
  type        = map(string)
  default     = null
}
