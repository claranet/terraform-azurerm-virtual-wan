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

variable "virtual_wan_id" {
  description = "ID of the Virtual Wan which host this Virtual Hub"
  type        = string
}

variable "virtual_hub_address_prefix" {
  description = "The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure"
  type        = string
  validation {
    condition     = tonumber(split("/", var.virtual_hub_address_prefix)[1]) <= 24
    error_message = "Virtual Hub address prefix must be at least /24. A /23 is recommended by Azure."
  }
}

variable "virtual_hub_sku" {
  description = "The SKU of the Virtual Hub. Possible values are `Basic` and `Standard`"
  type        = string
  default     = "Standard"
}

variable "virtual_hub_routes" {
  description = "List of route blocks. `next_hop_ip_address` values can be `azure_firewall` or an IP address."
  type = list(object({
    address_prefixes    = list(string),
    next_hop_ip_address = string
  }))
  default = []
}

variable "peered_virtual_networks" {
  description = "Virtual Networks to peer with the Virtual Hub."
  type = list(object({
    vnet_id                   = string
    peering_name              = optional(string)
    internet_security_enabled = optional(bool, true)

    routing = optional(object({
      associated_route_table_id = optional(string)

      propagated_route_table = optional(object({
        labels          = optional(list(string))
        route_table_ids = optional(list(string))
      }))

      static_vnet_route = optional(object({
        name                = optional(string)
        address_prefixes    = optional(list(string))
        next_hop_ip_address = optional(string)
      }))
    }))
  }))
  default = []
}

variable "internet_security_enabled" {
  description = "Define internet security parameter in Virtual Hub Connections if set"
  type        = bool
  default     = null
}
