variable "virtual_hub" {
  description = "ID of the Virtual Hub in which to deploy the firewall."
  type = object({
    id = string
  })
  nullable = false
}

variable "public_ip_count" {
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

variable "sku_tier" {
  description = "SKU tier of the firewall. Possible values are `Premium` and `Standard`."
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "dns_servers" {
  description = "List of DNS servers that the firewall will redirect DNS traffic to for the name resolution."
  type        = list(string)
  default     = null
}

variable "private_ip_ranges" {
  description = "List of SNAT private IP ranges, or the special string `IANAPrivateRanges`, which indicates the firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "zones" {
  description = "Availability zones in which the firewall should be created."
  type        = list(number)
  default     = [1, 2, 3]
  nullable    = false
}
