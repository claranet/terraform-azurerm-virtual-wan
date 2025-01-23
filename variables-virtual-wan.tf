variable "type" {
  description = "Specifies the Virtual WAN type. Possible Values are `Basic` and `Standard`. Defaults to `Standard`."
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "vpn_encryption_enabled" {
  description = "Boolean flag to specify whether VPN encryption is enabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "branch_to_branch_traffic_allowed" {
  description = "Boolean flag to specify whether branch to branch traffic is allowed."
  type        = bool
  default     = true
  nullable    = false
}

variable "office365_local_breakout_category" {
  description = "Specifies the Office365 local breakout category. Possible values are `Optimize`, `OptimizeAndAllow`, `All` and `None`. Defaults to `None`."
  type        = string
  default     = "None"
  nullable    = false
}

variable "internet_security_enabled" {
  description = "Define internet security parameter in both VPN connections and Virtual Hub connections."
  type        = bool
  default     = null
}
