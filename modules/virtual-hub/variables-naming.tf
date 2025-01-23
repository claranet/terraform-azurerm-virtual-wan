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

variable "custom_name" {
  description = "Custom Virtual Hub name."
  type        = string
  default     = null
}
