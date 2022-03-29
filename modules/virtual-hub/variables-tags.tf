variable "default_tags_enabled" {
  description = "Option to enabled or disable default tags"
  type        = bool
  default     = true
}

variable "virtual_hub_tags" {
  description = "tags for this Virtual Hub"
  type        = map(string)
  default     = {}
}
