variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
}
variable "extra_tags" {
  description = "Extra tags for the VPN Gateway"
  type        = map(string)
  default     = null
}
