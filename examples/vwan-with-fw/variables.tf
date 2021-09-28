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
