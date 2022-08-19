resource "azurerm_vpn_gateway" "vpn" {
  name                = local.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = var.virtual_hub_id

  routing_preference = var.vpn_gateway_routing_preference
  scale_unit         = var.vpn_gateway_scale_unit

  bgp_settings {
    # Fixed in the VWAN. Cannot be another value
    asn         = 65515
    peer_weight = var.vpn_gateway_bgp_peer_weight

    dynamic "instance_0_bgp_peering_address" {
      for_each = var.vpn_gateway_instance_0_bgp_peering_address != null ? ["fake"] : []
      content {
        custom_ips = var.vpn_gateway_instance_0_bgp_peering_address
      }
    }

    dynamic "instance_1_bgp_peering_address" {
      for_each = var.vpn_gateway_instance_1_bgp_peering_address != null ? ["fake"] : []
      content {
        custom_ips = var.vpn_gateway_instance_1_bgp_peering_address
      }
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_vpn_site" "vpn_site" {
  for_each            = { for site in var.vpn_sites : site.name => site }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = var.virtual_wan_id
  address_cidrs       = lookup(each.value, "address_cidrs", [])

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

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_vpn_gateway_connection" "vpn_gateway_connection" {
  for_each                  = { for conn in var.vpn_connections : conn.name => conn }
  name                      = each.key
  remote_vpn_site_id        = azurerm_vpn_site.vpn_site[each.value.site_name].id
  vpn_gateway_id            = azurerm_vpn_gateway.vpn.id
  internet_security_enabled = coalesce(lookup(each.value, "internet_security_enabled", null), var.internet_security_enabled, false)

  dynamic "vpn_link" {
    for_each = { for lnk in each.value.links : lnk.name => lnk }
    content {
      name                 = vpn_link.key
      vpn_site_link_id     = format("%s/vpnSiteLinks/%s", azurerm_vpn_site.vpn_site[each.value.site_name].id, vpn_link.key)
      egress_nat_rule_ids  = lookup(vpn_link.value, "egress_nat_rule_ids", null)
      ingress_nat_rule_ids = lookup(vpn_link.value, "ingress_nat_rule_ids", null)
      bandwidth_mbps       = lookup(vpn_link.value, "bandwidth_mbps", null)
      bgp_enabled          = lookup(vpn_link.value, "bgp_enabled", null)
      connection_mode      = lookup(vpn_link.value, "connection_mode", null)

      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy != null ? ["fake"] : []
        content {
          dh_group                 = lookup(vpn_link.value.ipsec_policy, "dh_group")
          encryption_algorithm     = lookup(vpn_link.value.ipsec_policy, "encryption_algorithm")
          ike_encryption_algorithm = lookup(vpn_link.value.ipsec_policy, "ike_encryption_algorithm")
          ike_integrity_algorithm  = lookup(vpn_link.value.ipsec_policy, "ike_integrity_algorithm")
          integrity_algorithm      = lookup(vpn_link.value.ipsec_policy, "integrity_algorithm")
          pfs_group                = lookup(vpn_link.value.ipsec_policy, "pfs_group")
          sa_data_size_kb          = lookup(vpn_link.value.ipsec_policy, "sa_data_size_kb")
          sa_lifetime_sec          = lookup(vpn_link.value.ipsec_policy, "sa_lifetime_sec")
        }
      }

      protocol                              = lookup(vpn_link.value, "protocol", null)
      ratelimit_enabled                     = lookup(vpn_link.value, "ratelimit_enabled", null)
      route_weight                          = lookup(vpn_link.value, "route_weight", null)
      shared_key                            = lookup(vpn_link.value, "shared_key", null)
      local_azure_ip_address_enabled        = lookup(vpn_link.value, "local_azure_ip_address_enabled", null)
      policy_based_traffic_selector_enabled = lookup(vpn_link.value, "policy_based_traffic_selector_enabled", null)
    }
  }
}
