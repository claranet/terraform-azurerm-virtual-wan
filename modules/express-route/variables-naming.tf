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

variable "gateway_custom_name" {
  description = "Custom Express Route gateway name."
  type        = string
  default     = null
}

variable "circuit_custom_name" {
  description = "Custom Express Route circuit name."
  type        = string
  default     = null
}
