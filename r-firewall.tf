resource "azurerm_firewall" "azfw" {
  for_each            = var.firewall_enabled ? toset(["firewall"]) : toset([])
  name                = local.fw_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "AZFW_Hub"
  sku_tier = var.firewall_sku_tier

  firewall_policy_id = var.firewall_policy_id
  threat_intel_mode  = ""

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub.id
    public_ip_count = var.firewall_public_ip_count
  }

  zones = var.firewall_availibility_zones

  dns_servers       = var.firewall_dns_servers
  private_ip_ranges = var.firewall_private_ip_ranges

  tags = merge(local.tags, var.firewall_extra_tags)
}
