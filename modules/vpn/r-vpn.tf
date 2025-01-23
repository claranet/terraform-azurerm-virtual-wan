resource "azurerm_vpn_gateway" "main" {
  name     = local.name
  location = var.location

  resource_group_name = var.resource_group_name

  virtual_hub_id = var.virtual_hub.id

  scale_unit         = var.scale_unit
  routing_preference = var.routing_preference

  bgp_settings {
    # Fixed in the Virtual WAN, cannot be another value
    asn         = 65515
    peer_weight = var.bgp_peer_weight

    dynamic "instance_0_bgp_peering_address" {
      for_each = var.instance_0_bgp_peering_address[*]
      content {
        custom_ips = instance_0_bgp_peering_address.value
      }
    }

    dynamic "instance_1_bgp_peering_address" {
      for_each = var.instance_1_bgp_peering_address[*]
      content {
        custom_ips = instance_1_bgp_peering_address.value
      }
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_vpn_gateway.vpn
  to   = azurerm_vpn_gateway.main
}

resource "azurerm_vpn_site" "main" {
  for_each = local.vpn_sites

  name     = each.key
  location = var.location

  resource_group_name = var.resource_group_name

  virtual_wan_id = var.virtual_wan.id

  address_cidrs = each.value.cidrs

  device_model  = each.value.device_model
  device_vendor = each.value.device_vendor

  dynamic "link" {
    for_each = each.value.links
    content {
      name          = link.value.name
      fqdn          = link.value.fqdn
      ip_address    = link.value.ip_address
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps

      dynamic "bgp" {
        for_each = link.value.bgp
        content {
          asn             = bgp.value.asn
          peering_address = bgp.value.peering_address
        }
      }
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_vpn_site.vpn_site
  to   = azurerm_vpn_site.main
}

resource "azurerm_vpn_gateway_connection" "main" {
  for_each = local.vpn_connections

  name = each.key

  vpn_gateway_id = azurerm_vpn_gateway.main.id

  remote_vpn_site_id = coalesce(each.value.site_id, azurerm_vpn_site.main[each.value.site_name].id)

  internet_security_enabled = coalesce(each.value.internet_security_enabled, var.internet_security_enabled)

  dynamic "vpn_link" {
    for_each = each.value.links
    content {
      name                                  = vpn_link.value.name
      vpn_site_link_id                      = format("%s/vpnSiteLinks/%s", coalesce(each.value.site_id, azurerm_vpn_site.main[each.value.site_name].id), vpn_link.value.name)
      egress_nat_rule_ids                   = vpn_link.value.egress_nat_rule_ids
      ingress_nat_rule_ids                  = vpn_link.value.ingress_nat_rule_ids
      bandwidth_mbps                        = vpn_link.value.bandwidth_mbps
      bgp_enabled                           = vpn_link.value.bgp_enabled
      connection_mode                       = vpn_link.value.connection_mode
      protocol                              = vpn_link.value.protocol
      ratelimit_enabled                     = vpn_link.value.ratelimit_enabled
      route_weight                          = vpn_link.value.route_weight
      shared_key                            = vpn_link.value.shared_key
      local_azure_ip_address_enabled        = vpn_link.value.local_azure_ip_address_enabled
      policy_based_traffic_selector_enabled = vpn_link.value.policy_based_traffic_selector_enabled

      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy[*]
        content {
          dh_group                 = ipsec_policy.value.dh_group
          encryption_algorithm     = ipsec_policy.value.encryption_algorithm
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption_algorithm
          ike_integrity_algorithm  = ipsec_policy.value.ike_integrity_algorithm
          integrity_algorithm      = ipsec_policy.value.integrity_algorithm
          pfs_group                = ipsec_policy.value.pfs_group
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
        }
      }
    }
  }

  dynamic "traffic_selector_policy" {
    for_each = each.value.traffic_selector_policy
    content {
      local_address_ranges  = traffic_selector_policy.value.local_address_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_address_ranges
    }
  }
}

moved {
  from = azurerm_vpn_gateway_connection.vpn_gateway_connection
  to   = azurerm_vpn_gateway_connection.main
}
