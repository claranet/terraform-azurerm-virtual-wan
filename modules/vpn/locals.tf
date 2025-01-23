locals {
  vpn_sites = {
    for item in var.vpn_sites : item.name => item
  }

  vpn_connections = {
    for item in var.vpn_connections : item.name => item
  }
}
