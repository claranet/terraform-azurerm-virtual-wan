variable "client_name" {
  description = "Client name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "stack" {
  description = "Stack name"
  type        = string
}

variable "azure_region" {
  description = "Azure region to use"
  type        = string
}

variable "virtual_wan_name" {
  description = "Name of the Virtual Wan in which the Virtual Hub will be deployed"
  type        = string
}

variable "virtual_wan_resource_group_name" {
  description = "Name of the resource group in which the Virtual Wan is deployed"
  type        = string
}
