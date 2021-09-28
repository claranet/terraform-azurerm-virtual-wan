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

variable "vnet_name" {
  description = "Name of the Spoke virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "List of CIDR ranges to use with the Spoke vnet."
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet to deploy into the Spoke Vnet."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "List of Spoke subnet CIDR ranges."
  type        = list(string)
}
