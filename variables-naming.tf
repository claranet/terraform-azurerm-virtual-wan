variable "name_prefix" {
  description = "Prefix for generated resources names."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Suffix for generated resources names."
  type        = string
  default     = ""
}

variable "name_slug" {
  description = "Slug to use with generated resources names."
  type        = string
  default     = ""
}

variable "custom_name" {
  description = "Custom Virtual WAN name."
  type        = string
  default     = null
}

variable "virtual_hub_custom_name" {
  description = "Custom Virtual Hub name."
  type        = string
  default     = null
}

variable "express_route_gateway_custom_name" {
  description = "Custom Express Route gateway name."
  type        = string
  default     = null
}

variable "express_route_circuit_custom_name" {
  description = "Custom Express Route circuit name."
  type        = string
  default     = null
}

variable "firewall_custom_name" {
  description = "Custom firewall name."
  type        = string
  default     = null
}

variable "vpn_gateway_custom_name" {
  description = "Custom VPN gateway name."
  type        = string
  default     = null
}
