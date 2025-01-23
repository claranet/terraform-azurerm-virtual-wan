module "routing_intent" {
  source  = "claranet/virtual-wan/azurerm//modules/routing-intent"
  version = "x.x.x"

  virtual_hub = module.virtual_hub

  next_hop_resource_id = data.azurerm_firewall.main.id
}
