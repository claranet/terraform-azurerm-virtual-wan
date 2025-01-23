variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project Stack name."
  type        = string
}

variable "virtual_wan_name" {
  description = "Name of the Virtual WAN in which the Virtual Hub will be deployed."
  type        = string
}

variable "virtual_wan_resource_group_name" {
  description = "Name of the Resource Group in which the Virtual WAN is deployed."
  type        = string
}

variable "firewall_name" {
  description = "Name of the Azure Firewall."
  type        = string
}

variable "firewall_resource_group_name" {
  description = "Name of the Resource Group in which the Azure Firewall is deployed."
  type        = string
}

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
}
