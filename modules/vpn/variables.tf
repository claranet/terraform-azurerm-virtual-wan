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

variable "vpn_gateway_routing_preference" {
  description = "Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet`"
  type        = string
  default     = "Microsoft Network"
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
  validation {
    condition     = alltrue([for ip in var.vpn_gateway_instance_0_bgp_peering_address : can(regex("169\\.254\\.2[1,2]\\.(?:25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip))]) || var.vpn_gateway_instance_0_bgp_peering_address == null
    error_message = "BPG Peering address must be in range 169.254.21.0/24 or 169.254.22.0/24."
  }
}

variable "vpn_gateway_instance_1_bgp_peering_address" {
  description = "List of custom BGP IP Addresses to assign to the second instance"
  type        = list(string)
  default     = null
  validation {
    condition     = alltrue([for ip in var.vpn_gateway_instance_1_bgp_peering_address : can(regex("169\\.254\\.2[1,2]\\.(?:25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip))]) || var.vpn_gateway_instance_1_bgp_peering_address == null
    error_message = "BPG Peering address must be in range 169.254.21.0/24 or 169.254.22.0/24."
  }
}

variable "vpn_gateway_scale_unit" {
  description = "The scale unit for this VPN Gateway"
  type        = number
  default     = 1
}

variable "vpn_sites" {
  description = "VPN Site configuration"
  type = list(object({
    name          = string,
    address_cidrs = optional(list(string))
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
  default = []
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub in which to deploy the VPN"
  type        = string
}

variable "virtual_wan_id" {
  description = "ID of the Virtual Wan who hosts the Virtual Hub"
  type        = string
}

variable "vpn_connections" {
  description = "VPN Connections configuration"
  type = list(object({
    name                      = string
    site_name                 = string
    internet_security_enabled = optional(bool)
    links = list(object({
      name                 = string,
      egress_nat_rule_ids  = optional(list(string))
      ingress_nat_rule_ids = optional(list(string))
      bandwidth_mbps       = optional(number)
      bgp_enabled          = optional(bool)
      connection_mode      = optional(string)
      ipsec_policy = optional(object({
        dh_group                 = string
        ike_encryption_algorithm = string
        ike_integrity_algorithm  = string
        encryption_algorithm     = string
        integrity_algorithm      = string
        pfs_group                = string
        sa_data_size_kb          = number
        sa_lifetime_sec          = number
      }))
      protocol                              = optional(string)
      ratelimit_enabled                     = optional(bool)
      route_weight                          = optional(number)
      shared_key                            = optional(string)
      local_azure_ip_address_enabled        = optional(bool)
      policy_based_traffic_selector_enabled = optional(bool)
    }))
  }))
  default = []
}

variable "internet_security_enabled" {
  description = "Define internet security parameter in VPN Connections if set"
  type        = bool
  default     = null
}
