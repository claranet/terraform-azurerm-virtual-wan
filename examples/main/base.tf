module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
}

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name
}

locals {
  vnets = [
    {
      name                      = "MyVNet1"
      cidrs                     = ["10.10.0.0/16"]
      internet_security_enabled = true
    },
    {
      name                      = "MyVNet2"
      cidrs                     = ["10.100.0.0/16"]
      internet_security_enabled = false
    },
  ]
}

module "vnets" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  for_each = {
    for vnet in local.vnets : vnet.name => vnet
  }

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  custom_name = each.key

  cidrs = each.value.cidrs
}

locals {
  subnets = [
    {
      name      = "MySubnet1OnVNet1"
      cidrs     = ["10.10.0.0/24"]
      vnet_name = module.vnets["MyVNet1"].name
    },
    {
      name      = "MySubnet2OnVNet1"
      cidrs     = ["10.10.1.0/24"]
      vnet_name = module.vnets["MyVNet1"].name
    },
    {
      name      = "MySubnet1OnVNet2"
      cidrs     = ["10.100.0.0/24"]
      vnet_name = module.vnets["MyVNet2"].name
    },
    {
      name      = "MySubnet2OnVNet2"
      cidrs     = ["10.100.1.0/24"]
      vnet_name = module.vnets["MyVNet2"].name
    },
  ]
}

module "subnets" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  for_each = {
    for subnet in local.subnets : subnet.name => subnet
  }

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  custom_name = each.key

  resource_group_name = module.rg.name

  virtual_network_name = each.value.vnet_name

  cidrs = each.value.cidrs
}
