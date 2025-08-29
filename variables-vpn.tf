variable "vpn_gateway_enabled" {
  description = "Whether or not to enable the deployment of a VPN gateway and its connections."
  type        = bool
  default     = false
  nullable    = false
}

variable "vpn_gateway_scale_unit" {
  description = "The scale unit for this VPN gateway."
  type        = number
  default     = 1
  nullable    = false
}

variable "vpn_gateway_routing_preference" {
  description = "Azure routing preference. You can choose to route traffic either via the Microsoft network (set to `Microsoft network`) or via the ISP network (set to `Internet`)."
  type        = string
  default     = "Microsoft Network"
  nullable    = false
}

variable "vpn_gateway_bgp_peer_weight" {
  description = "The weight added to routes learned from this BGP speaker."
  type        = number
  default     = 0
  nullable    = false
}

variable "vpn_gateway_instance_0_bgp_peering_address" {
  description = "List of custom BGP IP addresses to assign to the first instance."
  type        = list(string)
  default     = []
}

variable "vpn_gateway_instance_1_bgp_peering_address" {
  description = "List of custom BGP IP addresses to assign to the second instance."
  type        = list(string)
  default     = []
}

variable "vpn_sites" {
  description = "VPN sites configuration."
  type = list(object({
    name          = string
    cidrs         = optional(list(string))
    device_model  = optional(string)
    device_vendor = optional(string)
    links = list(object({
      name          = string
      fqdn          = optional(string)
      ip_address    = optional(string)
      provider_name = optional(string)
      speed_in_mbps = optional(number)
      bgp = optional(list(object({
        asn             = string
        peering_address = string
      })), [])
    }))
  }))
  default  = []
  nullable = false
}

variable "vpn_connections" {
  description = "VPN connections configuration."
  type = list(object({
    name                      = string
    site_id                   = optional(string)
    site_name                 = optional(string)
    internet_security_enabled = optional(bool, false)
    links = list(object({
      name                                  = string
      egress_nat_rule_names                 = optional(list(string), [])
      ingress_nat_rule_names                = optional(list(string), [])
      egress_nat_rule_ids                   = optional(list(string), [])
      ingress_nat_rule_ids                  = optional(list(string), [])
      bandwidth_mbps                        = optional(number, 10)
      bgp_enabled                           = optional(bool, false)
      connection_mode                       = optional(string, "Default")
      protocol                              = optional(string, "IKEv2")
      ratelimit_enabled                     = optional(bool, false)
      route_weight                          = optional(number, 0)
      shared_key                            = optional(string)
      local_azure_ip_address_enabled        = optional(bool, false)
      policy_based_traffic_selector_enabled = optional(bool, false)
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
    }))
    traffic_selector_policy = optional(list(object({
      local_address_ranges  = list(string)
      remote_address_ranges = list(string)
    })), [])
    routing = optional(object({
      associated_route_table = string
      propagated_route_table = optional(object({
        route_table_ids = list(string)
        labels          = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
  }))
  default  = []
  nullable = false
}

variable "nat_rules" {
  description = "List of NAT rules to apply to the VPN Gateway. For dynamic NAT rules, if `ip_configuration_name` is not set, the first IP configuration will be used."
  type = list(object({
    name = string
    external_mapping = list(object({
      address_space = string
      port_range    = optional(string)
    }))
    internal_mapping = list(object({
      address_space = string
      port_range    = optional(string)
    }))
    mode                           = string
    type                           = optional(string, "Static")
    ip_configuration_instance_name = optional(string, "Instance0")
    })
  )
  default  = []
  nullable = false
  validation {
    condition     = alltrue([for rule in var.nat_rules : (rule.mode == "IngressSnat" || rule.mode == "EgressSnat")])
    error_message = "Each NAT rule must use either 'IngressSnat' or 'EgressSnat' for the mode."
  }

  validation {
    condition     = alltrue([for rule in var.nat_rules : (rule.type == "Static" || rule.type == "Dynamic")])
    error_message = "Each NAT rule must use either 'Static' or 'Dynamic' for the type."
  }
}
