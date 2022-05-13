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

variable "express_route_gateway_scale_unit" {
  description = "The number of scale unit with which to provision the ExpressRoute Gateway."
  type        = number
  default     = 1
}
variable "express_route_circuit_peering_location" {
  description = "ExpressRoute Circuit peering location."
  type        = string
  default     = null
}

variable "express_route_circuit_bandwidth_in_mbps" {
  description = "The bandwith in Mbps of the ExpressRoute Circuit being created on the Service Provider"
  type        = number
  default     = null
}

variable "express_route_circuit_service_provider" {
  description = "The name of the ExpressRoute Circuit Service Provider."
  type        = string
  default     = null
}

variable "express_route_sku" {
  description = "ExpressRoute SKU"
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
  description = "Enable ExpressRoute Circuit Private Peering"
  type        = bool
  default     = false
}

variable "express_route_circuit_private_peering_primary_peer_address_prefix" {
  description = "Primary peer address prefix for ExpressRoute Circuit private peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_secondary_peer_address_prefix" {
  description = "Secondary peer address prefix for ExpressRoute Circuit private peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_shared_key" {
  description = "Shared secret key for ExpressRoute Circuit Private Peering"
  type        = string
  default     = null
}

variable "express_route_circuit_private_peering_vlan_id" {
  description = "VLAN ID for ExpressRoute Circuit"
  type        = number
  default     = null
}

variable "express_route_circuit_private_peering_peer_asn" {
  description = "Peer BGP ASN for ExpressRoute Circuit Private Peering"
  type        = number
  default     = null
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub in which to deploy the Firewall"
  type        = string
}
