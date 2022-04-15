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
# Virtual Wan specific variables
variable "custom_vwan_name" {
  description = "Custom Virtual Wan's name."
  type        = string
  default     = null
}

variable "vpn_encryption_enabled" {
  description = "Boolean flag to specify whether VPN encryption is enabled"
  type        = bool
  default     = true
}

variable "branch_to_branch_traffic_allowed" {
  description = "Boolean flag to specify whether branch to branch traffic is allowed"
  type        = bool
  default     = true
}

variable "office365_local_breakout_category" {
  description = "Specifies the Office365 local breakout category. Possible values include: `Optimize`, `OptimizeAndAllow`, `All`, `None`"
  type        = string
  default     = "None"
}

variable "virtual_wan_type" {
  description = "Specifies the Virtual Wan type. Possible Values include: `Basic` and `Standard`"
  type        = string
  default     = "Standard"
}

# Virtual Hub specific variables
variable "custom_virtual_hub_name" {
  description = "Custom Virtual Hub's name"
  type        = string
  default     = null
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

# Express route variables
variable "express_route_enabled" {
  description = "Enable or not Express Route configuration"
  type        = bool
  default     = false
}
variable "custom_express_route_gateway_name" {
  description = "Custom Express Route Gateway name"
  type        = string
  default     = null
}

variable "custom_express_route_circuit_name" {
  description = "Custom Express Route Circuit name"
  type        = string
  default     = null
}

variable "express_route_gateway_scale_unit" {
  description = "The number of scale unit with which to provision the Express Route Gateway."
  type        = number
  default     = 1
}
variable "express_route_circuit_peering_location" {
  description = "Express Route Circuit peering location."
  type        = string
  default     = null
}

variable "express_route_circuit_bandwidth_in_mbps" {
  description = "The bandwith in Mbps of the Express Route Circuit being created on the Service Provider"
  type        = number
  default     = null
}

variable "express_route_circuit_service_provider" {
  description = "The name of the Express Route Circuit Service Provider."
  type        = string
  default     = null
}

variable "express_route_sku" {
  description = "Express Route SKU"
  type = object({
    tier   = string,
    family = string
  })
  default = {
    tier   = "Premium"
    family = "MeteredData"
  }
}

variable "express_route_private_peering_enabled" {
  description = "Enable Express Route Circuit Private Peering"
  type        = bool
  default     = false
}

variable "express_route_circuit_private_peering_primary_peer_address_prefix" {
  description = "Primary peer address prefix for Express Route Circuit private peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_secondary_peer_address_prefix" {
  description = "Secondary peer address prefix for Express Route Circuit private peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_shared_key" {
  description = "Shared secret key for Express Route Circuit Private Peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_vlan_id" {
  description = "VLAN Id for Express Route Circuit"
  type        = number
  default     = null
}

variable "express_route_circuit_private_peering_peer_asn" {
  description = "Peer BGP ASN for Express Route Circuit Private Peering"
  type        = number
  default     = null
}

# Firewall specific variables
variable "firewall_enabled" {
  description = "Enable or not Azure Firewall in the Virtual Hub"
  type        = bool
  default     = true
}

variable "custom_firewall_name" {
  description = "Custom Firewall's name"
  type        = string
  default     = null
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

variable "peered_virtual_networks" {
  description = "List of Virtual Networks IDs to peer with the Virtual Hub."
  type        = list(string)
  default     = []
}

# VPN Gateway Specific variables
variable "vpn_gateway_enabled" {
  description = "Enable or not the deployment of a VPN Gateway and its Connections"
  type        = bool
  default     = false
}
variable "custom_vpn_gateway_name" {
  description = "Custom name for the VPN Gateway"
  type        = string
  default     = null
}

variable "vpn_gateway_routing_preference" {
  description = "Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet`"
  type        = string
  default     = "Microsoft Network"
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
  default = null
}

variable "vpn_gateway_instance_0_bgp_peering_address" {
  description = "List of custom BGP IP Addresses to assign to the first instance"
  type        = list(string)
  default     = []
}

variable "vpn_gateway_instance_1_bgp_peering_address" {
  description = "List of custom BGP IP Addresses to assign to the second instance"
  type        = list(string)
  default     = []
}

variable "vpn_connections" {
  description = "VPN Connections configuration"
  type = list(object({
    name                      = string
    site_name                 = string
    internet_security_enabled = optional(string)
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
  default = null
}
