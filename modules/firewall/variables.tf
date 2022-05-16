variable "client_name" {
  description = "Name of client."
  type        = string
}

variable "environment" {
  description = "Name of application's environment."
  type        = string
}

variable "stack" {
  description = "Name of application's stack."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application's resource group."
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "firewall_sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Premium` and `Standard`."
  type        = string
  default     = "Standard"
}

variable "firewall_policy_id" {
  description = "ID of the Firewall Policy applied to this Firewall."
  type        = string
  default     = null
}

variable "firewall_availibility_zones" {
  description = "Availability zones in which the Azure Firewall should be created."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "firewall_public_ip_count" {
  description = "Number of public IPs to assign to the Firewall."
  type        = number
  default     = 1
}

variable "firewall_dns_servers" {
  description = "List of DNS servers that the Azure Firewall will direct DNS traffic to for the name resolution"
  type        = list(string)
  default     = null
}

variable "firewall_private_ip_ranges" {
  description = "List of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918"
  type        = list(string)
  default     = null
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub in which to deploy the Firewall"
  type        = string
}

