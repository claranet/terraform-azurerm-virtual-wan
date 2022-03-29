variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
}

variable "express_route_gateway_tags" {
  description = "Extra tags for Express Route Gateway"
  type        = map(string)
  default     = {}
}
