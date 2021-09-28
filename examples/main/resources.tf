resource "azurerm_log_analytics_workspace" "logs" {
  location            = module.azure_region.location
  name                = var.log_analytics_workspace_name
  resource_group_name = module.rg.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = var.vnet_address_space
  name                = var.vnet_name
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.id

  address_prefixes = var.subnet_address_prefixes
}

resource "azurerm_virtual_hub_connection" "peer_vnet_to_hub" {
  name                      = "${azurerm_virtual_network.vnet.name}-to-hub"
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  virtual_hub_id            = module.virtual_wan.virtual_hub_id
}
