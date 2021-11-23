locals {
  vnets = [
    {
      vnet_name = "MyVnet1"
      vnet_cidr = "10.10.0.0/16"
    },
    {
      vnet_name = "MyVnet2"
      vnet_cidr = "10.100.0.0/16"
    }
  ]
  subnets = [
    {
      name      = "MySubnet1OnVnet1"
      cidr      = ["10.10.0.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet1"].virtual_network_name
    },
    {
      name      = "MySubnet2OnVnet1"
      cidr      = ["10.10.1.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet1"].virtual_network_name
    },
    {
      name      = "MySubnet1OnVnet2"
      cidr      = ["10.100.0.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet2"].virtual_network_name
    },
    {
      name      = "MySubnet2OnVnet2"
      cidr      = ["10.100.1.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet2"].virtual_network_name
    }
  ]
}
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_hub_address_prefix = "10.254.0.0/23"

  firewall_enabled                      = true
  express_route_enabled                 = true
  express_route_private_peering_enabled = true

  express_route_circuit_service_provider  = "Equinix"
  express_route_circuit_peering_location  = "Paris"
  express_route_circuit_bandwidth_in_mbps = 100

  express_route_circuit_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  express_route_circuit_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  express_route_circuit_private_peering_vlan_id                       = 1234
  express_route_circuit_private_peering_peer_asn                      = 4321
  express_route_circuit_private_peering_shared_key                    = "MySuperSecretSharedKey"

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id
  ]

  peered_virtual_networks = [for vnet in local.vnets : module.azure_virtual_network[vnet.vnet_name].virtual_network_id]

}

module "azure_virtual_network" {
  for_each = { for vnet in local.vnets : vnet.vnet_name => vnet }

  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment = var.environment
  client_name = var.client_name
  stack       = var.stack

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name

  custom_vnet_name = each.value.vnet_name
  vnet_cidr        = each.value.vnet_cidr
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  for_each    = { for subnet in local.subnets : subnet.name => subnet }
  environment = var.environment
  client_name = var.client_name
  stack       = var.stack

  location_short = module.azure_region.location_short

  custom_subnet_name = each.key

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = each.value.vnet_name
  subnet_cidr_list     = each.value

}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name
}
