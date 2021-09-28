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

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}
