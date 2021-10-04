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

  vhub_address_prefix = "10.254.0.0/23"

  enable_firewall           = true
  enable_express_route      = true
  enable_er_private_peering = true

  erc_service_provider  = "Equinix"
  erc_peering_location  = "Paris"
  erc_bandwidth_in_mbps = 100

  erc_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  erc_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  erc_private_peering_vlan_id                       = 1234
  erc_private_peering_peer_asn                      = 4321
  erc_private_peering_shared_key                    = "MySuperSecretSharedKey"

  logs_destinations_ids = [
    azurerm_log_analytics_workspace.logs.id
  ]
}


resource "azurerm_log_analytics_workspace" "logs" {
  location            = module.azure_region.location
  name                = "MyLogAnalyticWorkspace"
  resource_group_name = module.rg.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.10.0.0/16"]
  name                = "MyVnet"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "MySubnet"
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.id

  address_prefixes = ["10.10.0.0/24"]
}

resource "azurerm_virtual_hub_connection" "peer_vnet_to_hub" {
  name                      = "${azurerm_virtual_network.vnet.name}-to-hub"
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  virtual_hub_id            = module.virtual_wan.virtual_hub_id
}
