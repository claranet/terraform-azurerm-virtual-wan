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
      for_each = var.vpn_gateway_instance_0_bgp_peering_address[*]
      content {
        custom_ips = var.vpn_gateway_instance_0_bgp_peering_address
      }
    }

    dynamic "instance_1_bgp_peering_address" {
      for_each = var.vpn_gateway_instance_1_bgp_peering_address[*]
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
  address_cidrs       = each.value.address_cidrs

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
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps
    }
  }

  device_model  = each.value.device_model
  device_vendor = each.value.device_vendor

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_vpn_gateway_connection" "vpn_gateway_connection" {
  for_each                  = { for conn in var.vpn_connections : conn.name => conn }
  name                      = each.key
  remote_vpn_site_id        = each.value.site_id != null ? each.value.site_id : azurerm_vpn_site.vpn_site[each.value.site_name].id
  vpn_gateway_id            = azurerm_vpn_gateway.vpn.id
  internet_security_enabled = coalesce(lookup(each.value, "internet_security_enabled", null), var.internet_security_enabled, false)

  dynamic "vpn_link" {
    for_each = { for lnk in each.value.links : lnk.name => lnk }
    content {
      name                 = vpn_link.key
      vpn_site_link_id     = format("%s/vpnSiteLinks/%s", each.value.site_id != null ? each.value.site_id : azurerm_vpn_site.vpn_site[each.value.site_name].id, vpn_link.key)
      egress_nat_rule_ids  = vpn_link.value.egress_nat_rule_ids
      ingress_nat_rule_ids = vpn_link.value.ingress_nat_rule_ids
      bandwidth_mbps       = vpn_link.value.bandwidth_mbps
      bgp_enabled          = vpn_link.value.bgp_enabled
      connection_mode      = vpn_link.value.connection_mode

      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy[*]
        content {
          dh_group                 = vpn_link.value.ipsec_policy.dh_group
          encryption_algorithm     = vpn_link.value.ipsec_policy.encryption_algorithm
          ike_encryption_algorithm = vpn_link.value.ipsec_policy.ike_encryption_algorithm
          ike_integrity_algorithm  = vpn_link.value.ipsec_policy.ike_integrity_algorithm
          integrity_algorithm      = vpn_link.value.ipsec_policy.integrity_algorithm
          pfs_group                = vpn_link.value.ipsec_policy.pfs_group
          sa_data_size_kb          = vpn_link.value.ipsec_policy.sa_data_size_kb
          sa_lifetime_sec          = vpn_link.value.ipsec_policy.sa_lifetime_sec
        }
      }

      protocol                              = vpn_link.value.protocol
      ratelimit_enabled                     = vpn_link.value.ratelimit_enabled
      route_weight                          = vpn_link.value.route_weight
      shared_key                            = vpn_link.value.shared_key
      local_azure_ip_address_enabled        = vpn_link.value.local_azure_ip_address_enabled
      policy_based_traffic_selector_enabled = vpn_link.value.policy_based_traffic_selector_enabled
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
