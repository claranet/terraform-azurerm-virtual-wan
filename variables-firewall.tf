variable "firewall_enabled" {
  description = "Enable or disable Azure Firewall in the Virtual Hub."
  type        = bool
  default     = true
  nullable    = false
}

variable "firewall_public_ip_count" {
  description = "Number of public IPs to assign to the firewall."
  type        = number
  default     = 1
  nullable    = false
}

variable "firewall_policy" {
  description = "ID of the firewall policy applied to this firewall."
  type = object({
    id = string
  })
  default = null
}

variable "firewall_sku_tier" {
  description = "SKU tier of the firewall. Possible values are `Premium` and `Standard`."
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "firewall_dns_servers" {
  description = "List of DNS servers that the firewall will redirect DNS traffic to for the name resolution."
  type        = list(string)
  default     = null
}

variable "firewall_private_ip_ranges" {
  description = "List of SNAT private IP ranges, or the special string `IANAPrivateRanges`, which indicates the firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "firewall_zones" {
  description = "Availability zones in which the firewall should be created."
  type        = list(number)
  default     = [1, 2, 3]
  nullable    = false
}
