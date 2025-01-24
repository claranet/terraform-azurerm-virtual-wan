module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_hub_address_prefix = "10.254.0.0/23"
  peered_virtual_networks = [
    for vnet in local.vnets : {
      vnet_id                   = module.vnets[vnet.name].id
      internet_security_enabled = vnet.internet_security_enabled
    }
  ]

  firewall_enabled                      = true
  express_route_enabled                 = true
  express_route_private_peering_enabled = true
  vpn_gateway_enabled                   = true

  express_route_circuit_peering_location  = "Paris"
  express_route_circuit_bandwidth_in_mbps = 100
  express_route_circuit_service_provider  = "Equinix"

  express_route_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  express_route_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  express_route_private_peering_shared_key                    = "MySuperSecretSharedKey"
  express_route_private_peering_peer_asn                      = 4321
  express_route_private_peering_vlan_id                       = 1234

  vpn_gateway_instance_0_bgp_peering_address = ["169.254.21.1"]
  vpn_gateway_instance_1_bgp_peering_address = ["169.254.22.1"]

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
        name           = "site1-primary-link"
        bandwidth_mbps = 200
        bgp_enabled    = true
        protocol       = "IKEv2"
        shared_key     = "VeryStrongSecretKeyForPrimaryLink"
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
        name           = "site1-secondary-link"
        bandwidth_mbps = 200
        bgp_enabled    = true
        protocol       = "IKEv2"
        shared_key     = "VeryStrongSecretKeyForSecondaryLink"
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
  }]

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]
}
