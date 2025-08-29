module "vpn" {
  source  = "claranet/virtual-wan/azurerm//modules/vpn"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_wan = data.azurerm_virtual_wan.main
  virtual_hub = module.virtual_hub

  instance_0_bgp_peering_address = ["169.254.21.1"]
  instance_1_bgp_peering_address = ["169.254.22.1"]

  vpn_sites = [{
    name = "site1"
    links = [
      {
        name       = "site1-primary-endpoint"
        ip_address = "20.20.20.20"
        bgp = [{
          asn             = 65530
          peering_address = "169.254.21.2"
        }]
      },
      {
        name       = "site1-secondary-endpoint"
        ip_address = "21.21.21.21"
        bgp = [{
          asn             = 65530
          peering_address = "169.254.22.2"
        }]
      },
    ]
  }]

  vpn_connections = [{
    name      = "cn-hub-to-site1"
    site_name = "site1"
    links = [
      {
        name                  = "site1-primary-link"
        bandwidth_mbps        = 200
        bgp_enabled           = true
        protocol              = "IKEv2"
        shared_key            = "VeryStrongSecretKeyForPrimaryLink"
        egress_nat_rule_names = ["nat-egress-xxx"]
        ipsec_policy = {
          dh_group                 = "DHGroup14"
          ike_encryption_algorithm = "AES256"
          ike_integrity_algorithm  = "SHA256"
          encryption_algorithm     = "AES256"
          integrity_algorithm      = "SHA256"
          pfs_group                = "PFS14"
          sa_data_size_kb          = 102400000
          sa_lifetime_sec          = 3600
        }
      },
      {
        name                                  = "site1-secondary-link"
        bandwidth_mbps                        = 200
        bgp_enabled                           = true
        protocol                              = "IKEv2"
        shared_key                            = "VeryStrongSecretKeyForSecondaryLink"
        policy_based_traffic_selector_enabled = true
        ipsec_policy = {
          dh_group                 = "DHGroup14"
          ike_encryption_algorithm = "AES256"
          ike_integrity_algorithm  = "SHA256"
          encryption_algorithm     = "AES256"
          integrity_algorithm      = "SHA256"
          pfs_group                = "PFS14"
          sa_data_size_kb          = 102400000
          sa_lifetime_sec          = 3600
        }
      },
    ]
    traffic_selector_policy = [{
      local_address_ranges  = ["10.0.0.0/16"],
      remote_address_ranges = ["10.92.34.50/32"]
    }]
  }]

  # NAT RULES example
  nat_rules = [
    {
      name = "nat-egress-xxx"
      mode = "EgressSnat"
      type = "Static"
      internal_mapping = [
        {
          address_space = "10.10.10.0/24"
        }
      ]
      external_mapping = [
        {
          address_space = "192.168.1.0/24"
        }
      ]
    },
  ]

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]

  extra_tags = var.extra_tags
}
