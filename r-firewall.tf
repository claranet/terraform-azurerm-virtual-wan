resource "azurerm_firewall" "azfw" {
  for_each            = var.enable_firewall ? toset(["firewall"]) : toset([])
  name                = local.fw_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "AZFW_Hub"
  sku_tier = var.fw_sku_tier

  firewall_policy_id = var.fw_policy_id
  threat_intel_mode  = ""

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub.id
    public_ip_count = var.fw_public_ip_count
  }

  zones = var.fw_availibility_zones

  dns_servers       = var.fw_dns_servers
  private_ip_ranges = var.fw_private_ip_ranges

  tags = merge(local.tags, var.fw_extra_tags)
}
