variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Tags for Firewall resource"
  type        = map(string)
  default     = {}
}
