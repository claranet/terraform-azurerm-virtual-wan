resource "azurerm_vpn_gateway" "vpn" {
  name                = local.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = var.virtual_hub_id

  routing_preferences = var.vpn_gateway_routing_preference
  scale_unit          = var.vpn_gateway_scale_unit

  tags = var.vpn_gateway_tags
}

resource "azurerm_vpn_site" "vpn_site" {
  for_each            = { for site in var.vpn_site : site.name => site }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = each.value.virtual_wan_id
  address_cidrs       = lookup(each.value, "address_cidrs", null)

  dynamic "link" {
    for_each = toset(each.value.links)
    content {
      name       = link.value.name
      fqdn       = link.value.fqdn
      ip_address = link.value.ip_address

      dynamic "bgp" {
        for_each = link.value.bgp
        content {
          asn             = bgp.value.asn
          peering_address = bgp.value.peering_address
        }
      }
      provider_name = lookup(link.value, "provider_name", null)
      speed_in_mbps = lookup(link.value, "speed_in_mbps", null)
    }
  }

  device_model  = lookup(each.value, "device_model", null)
  device_vendor = lookup(each.value, "device_vendor", null)
}

resource "azurerm_vpn_gateway_connection" "vpn_gateway_connection" {
  name               = local.vpn_gateway_connection_name
  remote_vpn_site_id = azurerm_vpn_site.vpn_site.id
  vpn_gateway_id     = azurerm_vpn_gateway.vpn.id

  dynamic "vpn_link" {
    for_each = toset(azurerm_vpn_site.vpn_site.link[*].id)
    content {
      name             = element(split("/", vpn_link.value), length(split("/", vpn_link.value) - 1))
      vpn_site_link_id = vpn_link.value
    }
  }
}
