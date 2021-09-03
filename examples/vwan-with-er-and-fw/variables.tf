variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "stack" {
  type = string
}

variable "azure_region" {
  type = string
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "vhub_address_prefix" {
  type = string
}

variable "erc_service_provider" {
  type = string
}

variable "erc_peering_location" {
  type = string
}

variable "erc_bandwidth_in_mbps" {
  type = number
}

variable "erc_private_peering_primary_peer_address_prefix" {
  type = string
}

variable "erc_private_peering_secondary_peer_address_prefix" {
  type = string
}

variable "erc_private_peering_vlan_id" {
  type = number
}

variable "erc_private_peering_peer_asn" {
  type = number
}

variable "erc_private_peering_shared_key" {
  type = string
}
