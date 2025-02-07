locals {
  peered_virtual_networks = {
    for item in var.peered_virtual_networks : item.vnet_id => item
  }
}
