variable "virtual_wan" {
  description = "ID of the Virtual WAN containing this Virtual Hub."
  type = object({
    id = string
  })
  nullable = false
}

variable "sku" {
  description = "The SKU of the Virtual Hub. Possible values are `Basic` and `Standard`."
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "address_prefix" {
  description = "The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure."
  type        = string
  nullable    = false

  validation {
    condition     = tonumber(split("/", var.address_prefix)[1]) <= 24
    error_message = "Virtual Hub address prefix must be at least /24. A /23 is recommended by Azure."
  }
}

variable "routes" {
  description = "List of route objects. `var.routes[*].next_hop_ip_address` values can be `azure_firewall` or an IP address."
  type = list(object({
    address_prefixes    = list(string)
    next_hop_ip_address = string
  }))
  default  = []
  nullable = false
}

variable "peered_virtual_networks" {
  description = "List of Virtual Network objects to peer with the Virtual Hub."
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
  default  = []
  nullable = false
}

variable "internet_security_enabled" {
  description = "Enable or disable internet security for Virtual Hub connections."
  type        = bool
  default     = null
}
