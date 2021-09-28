terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = ">= 2.74"
  }
}

provider "azurerm" {
  features {}
}
