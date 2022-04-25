variable "name_prefix" {
  description = "Prefix for generated resources names."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Suffix for the generated resources names."
  type        = string
  default     = ""
}

variable "name_slug" {
  description = "Slug to use with the generated resources names."
  type        = string
  default     = ""
}

variable "custom_vwan_name" {
  description = "Custom Virtual Wan's name."
  type        = string
  default     = null
}

variable "custom_virtual_hub_name" {
  description = "Custom Virtual Hub's name"
  type        = string
  default     = null
}

variable "custom_express_route_gateway_name" {
  description = "Custom ExpressRoute Gateway name"
  type        = string
  default     = null
}

variable "custom_express_route_circuit_name" {
  description = "Custom ExpressRoute Circuit name"
  type        = string
  default     = null
}

variable "custom_firewall_name" {
  description = "Custom Firewall's name"
  type        = string
  default     = null
}

variable "custom_vpn_gateway_name" {
  description = "Custom name for the VPN Gateway"
  type        = string
  default     = null
}
