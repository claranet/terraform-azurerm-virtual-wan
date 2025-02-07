variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
  nullable    = false
}

variable "extra_tags" {
  description = "Additional tags to add to the firewall."
  type        = map(string)
  default     = null
}
