module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  location    = module.azure_region.location
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
}

data "azurerm_virtual_wan" "virtual_wan" {
  name                = var.virtual_wan_name
  resource_group_name = var.virtual_wan_resource_group_name
}

module "virtual_hub" {
  source  = "claranet/virtual-wan/azurerm//modules/virtual-hub"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_hub_address_prefix = "10.0.0.0/23"
  virtual_wan_id             = data.azurerm_virtual_wan.virtual_wan.id

  extra_tags = local.tags
}

module "vpn" {
  source  = "claranet/virtual-wan/azurerm//modules/vpn"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
  ]

  virtual_wan_id = data.azurerm_virtual_wan.virtual_wan.id
  virtual_hub_id = module.virtual_hub.virtual_hub_id

  vpn_gateway_instance_0_bgp_peering_address = ["169.254.21.1"]
  vpn_gateway_instance_1_bgp_peering_address = ["169.254.22.1"]

  vpn_sites = [
    {
      name = "site1"
      links = [
        {
          name       = "site1-primary-endpoint"
          ip_address = "20.20.20.20"
          bgp = [
            {
              asn             = 65530
              peering_address = "169.254.21.2"
            }
          ]
        },
        {
          name       = "site1-secondary-endpoint"
          ip_address = "21.21.21.21"
          bgp = [
            {
              asn             = 65530
              peering_address = "169.254.22.2"
            }
          ]
        }
      ]
    }
  ]

  vpn_connections = [
    {
      name      = "cn-hub-to-site1"
      site_name = "site1"
      links = [
        {
          name           = "site1-primary-link"
          bandwidth_mbps = 200
          bgp_enabled    = true
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
          protocol   = "IKEv2"
          shared_key = "VeryStrongSecretKeyForPrimaryLink"
        },
        {
          name           = "site1-secondary-link"
          bandwidth_mbps = 200
          bgp_enabled    = true
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
          protocol   = "IKEv2"
          shared_key = "VeryStrongSecretKeyForSecondaryLink"
        }
      ]
    }
  ]
  extra_tags = local.tags
}

locals {
  tags = {
    env   = "prod"
    stack = "hub"
  }
}
