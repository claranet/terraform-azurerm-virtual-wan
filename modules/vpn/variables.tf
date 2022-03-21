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

variable "name_prefix" {
  description = "Prefix for generated resources names."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Suffix for the generated resources names."
  type        = string
  default     = ""
}

variable "name_slug" {
  description = "Slug to use with the generated resources names."
  type        = string
  default     = ""
}

variable "logs_destinations_ids" {
  description = "List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set."
  type        = list(string)
}
# VPN Specific variables
variable "custom_vpn_gateway_name" {
  description = "Custom name for the VPN Gateway"
  type        = string
  default     = null
}

variable "custom_vpn_gateway_connection_name" {
  description = "Custom name for the VPN Connection"
  type        = string
  default     = null
}

variable "vpn_gateway_tags" {
  description = "Extra tags for the VPN Gateway"
  type        = map(string)
  default     = null
}

variable "vpn_gateway_routing_preference" {
  description = "Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet`"
  type        = string
  default     = "Microsoft network"
}

variable "vpn_gateway_bgp_asn" {
  description = "Peer ASN of this vpn gateway"
  type        = number
}

variable "vpn_gateway_bgp_peer_weight" {
  description = "The weight added to Routes learned from this BGP Speaker."
  type        = number
  default     = 0
}

variable "vpn_gateway_instance_0_bgp_peering_address" {
  description = "List of custom BGP IP Addresses to assign to the first instance"
  type        = list(string)
  default     = null
}

variable "vpn_gateway_instance_1_bgp_peering_address" {
  description = "List of custom BGP IP Addresses to assign to the second instance"
  type        = list(string)
  default     = null
}


variable "vpn_gateway_scale_unit" {
  description = "The scale unit for this VPN Gateway"
  type        = number
  default     = 1
}

variable "vpn_site" {
  description = "VPN Site configuration"
  type = list(object({
    name           = string,
    address_cidrs  = list(string)
    virtual_wan_id = string
    links = list(object({
      name       = string
      fqdn       = optional(string)
      ip_address = optional(string)
      bgp = optional(list(object({
        asn             = string
        peering_address = string
      })))
      provider_name = optional(string)
      speed_in_mbps = optional(string)
    }))
    device_model  = optional(string)
    device_vendor = optional(string)
  }))
  default = null
}

variable "virtual_hub_id" {
  description = "Id of the Virtual Hub in which to deploy the Firewall"
  type        = string
}
