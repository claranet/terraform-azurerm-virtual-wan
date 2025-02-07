variable "location" {
  description = "Azure location."
  type        = string
  nullable    = false
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
  nullable    = false
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
  nullable    = false
}

variable "environment" {
  description = "Project environment."
  type        = string
  nullable    = false
}

variable "stack" {
  description = "Project Stack name."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
  nullable    = false
}
