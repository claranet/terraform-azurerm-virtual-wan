locals {
  vpn_connections_ids = {
    for key, value in azurerm_vpn_gateway_connection.main : key => value.id
  }
}
