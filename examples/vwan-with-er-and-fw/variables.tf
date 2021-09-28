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

variable "azure_region" {
  description = "Name of the Region."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the log Analytics Workspace."
  type        = string
}

variable "vhub_address_prefix" {
  description = "CIDR Range to use with the virtual hub. /24 mini, /23 recommended."
  type        = string
}

variable "erc_service_provider" {
  description = "The name of the ExpressRoute Service Provider."
  type        = string
}

variable "erc_peering_location" {
  description = "The name of the peering location that this Express Route is."
  type        = string
}

variable "erc_bandwidth_in_mbps" {
  description = "The bandwith in Mbps of the circuit being created on the Service Provider"
  type        = number
}

variable "erc_private_peering_primary_peer_address_prefix" {
  description = "Primary peer address prefix for Express Route Circuit private peering"
  type        = string
}

variable "erc_private_peering_secondary_peer_address_prefix" {
  description = "Secondary peer address prefix for Express Route Circuit private peering"
  type        = string
}

variable "erc_private_peering_vlan_id" {
  description = "VLAN Id for Express Route "
  type        = number
}

variable "erc_private_peering_peer_asn" {
  description = "Peer BGP ASN for Express Route Circuit Private Peering"
  type        = number
}

variable "erc_private_peering_shared_key" {
  description = "Shared secret key for Express Route Circuit Private Peering"
  type        = string
}
