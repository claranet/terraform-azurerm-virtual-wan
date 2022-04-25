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

variable "custom_express_route_gateway_name" {
  description = "Custom Express Route Gateway name"
  type        = string
  default     = null
}

variable "custom_express_route_circuit_name" {
  description = "Custom Express Route Circuit name"
  type        = string
  default     = null
}
