resource "azurerm_firewall" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  virtual_hub {
    virtual_hub_id  = var.virtual_hub.id
    public_ip_count = var.public_ip_count
  }

  firewall_policy_id = try(var.firewall_policy.id, null)

  sku_name = "AZFW_Hub"
  sku_tier = var.sku_tier

  dns_servers       = var.dns_servers
  private_ip_ranges = var.private_ip_ranges

  zones = var.zones

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_firewall.azfw
  to   = azurerm_firewall.main
}
