variable "virtual_hub" {
  description = "ID of the Virtual Hub in which to deploy the Express Route."
  type = object({
    id = string
  })
  nullable = false
}

variable "gateway_scale_unit" {
  description = "The number of scale units with which to provision the Express Route gateway."
  type        = number
  default     = 1
  nullable    = false
}

variable "gateway_non_virtual_wan_traffic_allowed" {
  description = "Whether the gateway accepts traffic from non-Virtual WAN networks."
  type        = bool
  default     = false
  nullable    = false
}

variable "circuit_peering_location" {
  description = "Express Route circuit peering location."
  type        = string
  nullable    = false
}

variable "circuit_bandwidth_in_mbps" {
  description = "The bandwidth in Mbps of the Express Route circuit being created on the service provider."
  type        = number
  nullable    = false
}

variable "circuit_service_provider" {
  description = "The name of the Express Route circuit service provider."
  type        = string
  nullable    = false
}

variable "circuit_sku" {
  description = "Express Route circuit SKU."
  type = object({
    tier   = string
    family = string
  })
  default = {
    tier   = "Premium"
    family = "MeteredData"
  }
  nullable = false
}

variable "private_peering_enabled" {
  description = "Whether or not to enable private peering on the Express Route circuit."
  type        = bool
  default     = false
  nullable    = false
}

variable "private_peering_primary_peer_address_prefix" {
  description = "Primary peer address prefix for the Express Route circuit private peering."
  type        = string
  default     = null
}

variable "private_peering_secondary_peer_address_prefix" {
  description = "Secondary peer address prefix for the Express Route circuit private peering."
  type        = string
  default     = null
}

variable "private_peering_shared_key" {
  description = "Shared secret key for the Express Route circuit private peering."
  type        = string
  default     = null
}

variable "private_peering_peer_asn" {
  description = "Peer BGP ASN for the Express Route circuit private peering."
  type        = number
  default     = null
}

variable "private_peering_vlan_id" {
  description = "VLAN ID for the Express Route circuit."
  type        = number
  default     = null
}
