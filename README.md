# Azure Virtual Wan
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/virtual-wan/azurerm/)

Azure Virtual Wan module to create a Virtual Wan with one Virtual Hub, an Azure Firewall and an Express Route Circuit with its Private Peering and VPN connections. An infrastructure example referenced in the Azure Cloud Adoption Framework is available here: [raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf](https://raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf)

This module use multiple sub-modules:

  * [Virtual Hub](./modules/virtual-hub/README.md): Manage all Virtual Hub configurations
  * [Azure Firewall](./modules/firewall/README.md): Manage the creation of Azure Firewall in a Secured Hub
  * [Azure ExpressRoute](./modules/express-route/README.md): Manage ExpressRoute creation and configuration
  * [Azure VPN](./modules/vpn/README.md): Manage VPN connection in a Virtual Hub

## Naming

Resource naming is based on the [Microsoft CAF naming convention best practices](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). Use the parameter `custom_<resource>_name` to override names.
We rely on [the official Terraform Azure CAF naming provider](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) to generate resource names.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
locals {
  vnets = [
    {
      vnet_name                 = "MyVnet1"
      vnet_cidr                 = ["10.10.0.0/16"]
      internet_security_enabled = true
    },
    {
      vnet_name                 = "MyVnet2"
      vnet_cidr                 = ["10.100.0.0/16"]
      internet_security_enabled = false
    }
  ]
  subnets = [
    {
      name      = "MySubnet1OnVnet1"
      cidr      = ["10.10.0.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet1"].virtual_network_name
    },
    {
      name      = "MySubnet2OnVnet1"
      cidr      = ["10.10.1.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet1"].virtual_network_name
    },
    {
      name      = "MySubnet1OnVnet2"
      cidr      = ["10.100.0.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet2"].virtual_network_name
    },
    {
      name      = "MySubnet2OnVnet2"
      cidr      = ["10.100.1.0/24"]
      vnet_name = module.azure_virtual_network["MyVnet2"].virtual_network_name
    }
  ]
}
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  virtual_hub_address_prefix = "10.254.0.0/23"

  firewall_enabled                      = true
  express_route_enabled                 = true
  express_route_private_peering_enabled = true
  vpn_gateway_enabled                   = true

  express_route_circuit_service_provider  = "Equinix"
  express_route_circuit_peering_location  = "Paris"
  express_route_circuit_bandwidth_in_mbps = 100

  express_route_circuit_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  express_route_circuit_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  express_route_circuit_private_peering_vlan_id                       = 1234
  express_route_circuit_private_peering_peer_asn                      = 4321
  express_route_circuit_private_peering_shared_key                    = "MySuperSecretSharedKey"

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id
  ]

  peered_virtual_networks = [
    for vnet in local.vnets : {
      vnet_id                   = module.azure_virtual_network[vnet.vnet_name].virtual_network_id
      internet_security_enabled = vnet.internet_security_enabled
      # routing = {}
    }
  ]

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
}

module "azure_virtual_network" {
  for_each = { for vnet in local.vnets : vnet.vnet_name => vnet }

  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment = var.environment
  client_name = var.client_name
  stack       = var.stack

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name

  custom_vnet_name = each.value.vnet_name
  vnet_cidr        = each.value.vnet_cidr
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  for_each    = { for subnet in local.subnets : subnet.name => subnet }
  environment = var.environment
  client_name = var.client_name
  stack       = var.stack

  location_short = module.azure_region.location_short

  custom_subnet_name = each.key

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = each.value.vnet_name
  subnet_cidr_list     = each.value.cidr

}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| express\_route | ./modules/express-route | n/a |
| firewall | ./modules/firewall | n/a |
| vhub | ./modules/virtual-hub | n/a |
| vpn | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_wan.vwan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) | resource |
| [azurecaf_name.virtual_wan_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| branch\_to\_branch\_traffic\_allowed | Boolean flag to specify whether branch to branch traffic is allowed | `bool` | `true` | no |
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_express\_route\_circuit\_name | Custom ExpressRoute Circuit name | `string` | `null` | no |
| custom\_express\_route\_gateway\_name | Custom ExpressRoute Gateway name | `string` | `null` | no |
| custom\_firewall\_name | Custom Firewall's name | `string` | `null` | no |
| custom\_virtual\_hub\_name | Custom Virtual Hub's name | `string` | `null` | no |
| custom\_vpn\_gateway\_name | Custom name for the VPN Gateway | `string` | `null` | no |
| custom\_vwan\_name | Custom Virtual Wan's name. | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwith in Mbps of the ExpressRoute Circuit being created on the Service Provider | `number` | `null` | no |
| express\_route\_circuit\_peering\_location | ExpressRoute Circuit peering location. | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_peer\_asn | Peer BGP ASN for ExpressRoute Circuit Private Peering | `number` | `null` | no |
| express\_route\_circuit\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_shared\_key | Shared secret key for ExpressRoute Circuit Private Peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_vlan\_id | VLAN Id for ExpressRoute Circuit | `number` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the ExpressRoute Circuit Service Provider. | `string` | `null` | no |
| express\_route\_custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| express\_route\_enabled | Enable or not ExpressRoute configuration | `bool` | `false` | no |
| express\_route\_gateway\_extra\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| express\_route\_gateway\_scale\_unit | The number of scale unit with which to provision the ExpressRoute Gateway. | `number` | `1` | no |
| express\_route\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| express\_route\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| express\_route\_private\_peering\_enabled | Enable ExpressRoute Circuit Private Peering | `bool` | `false` | no |
| express\_route\_sku | ExpressRoute SKU | <pre>object({<br>    tier   = string,<br>    family = string<br>  })</pre> | <pre>{<br>  "family": "MeteredData",<br>  "tier": "Premium"<br>}</pre> | no |
| extra\_tags | Map of additional tags. | `map(string)` | `{}` | no |
| firewall\_availibility\_zones | Availability zones in which the Azure Firewall should be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| firewall\_custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| firewall\_dns\_servers | List of DNS servers that the Azure Firewall will direct DNS traffic to for the name resolution | `list(string)` | `null` | no |
| firewall\_enabled | Enable or not Azure Firewall in the Virtual Hub | `bool` | `true` | no |
| firewall\_extra\_tags | Extra tags for Firewall resource | `map(string)` | `{}` | no |
| firewall\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| firewall\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| firewall\_policy\_id | ID of the Firewall Policy applied to this Firewall. | `string` | `null` | no |
| firewall\_private\_ip\_ranges | List of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918 | `list(string)` | `null` | no |
| firewall\_public\_ip\_count | Number of public IPs to assign to the Firewall. | `number` | `1` | no |
| firewall\_sku\_tier | SKU tier of the Firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| internet\_security\_enabled | Define internet security parameter in both VPN Connections and Virtual Hub Connections if set | `bool` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| office365\_local\_breakout\_category | Specifies the Office365 local breakout category. Possible values include: `Optimize`, `OptimizeAndAllow`, `All`, `None` | `string` | `"None"` | no |
| peered\_virtual\_networks | Virtual Networks to peer with the Virtual Hub. | <pre>list(object({<br>    vnet_id                   = string<br>    peering_name              = optional(string)<br>    internet_security_enabled = optional(bool, true)<br><br>    routing = optional(object({<br>      associated_route_table_id = optional(string)<br><br>      propagated_route_table = optional(object({<br>        labels          = optional(list(string))<br>        route_table_ids = optional(list(string))<br>      }))<br><br>      static_vnet_route = optional(object({<br>        name                = optional(string)<br>        address_prefixes    = optional(list(string))<br>        next_hop_ip_address = optional(string)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| virtual\_hub\_address\_prefix | The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure | `string` | n/a | yes |
| virtual\_hub\_extra\_tags | Extra tags for this Virtual Hub | `map(string)` | `{}` | no |
| virtual\_hub\_routes | List of route blocks. `next_hop_ip_address` values can be `azure_firewall` or an IP address. | <pre>list(object({<br>    address_prefixes    = list(string),<br>    next_hop_ip_address = string<br>  }))</pre> | `[]` | no |
| virtual\_hub\_sku | The SKU of the Virtual Hub. Possible values are `Basic` and `Standard` | `string` | `"Standard"` | no |
| virtual\_wan\_extra\_tags | Extra tags for this Virtual Wan | `map(string)` | `{}` | no |
| virtual\_wan\_type | Specifies the Virtual Wan type. Possible Values include: `Basic` and `Standard` | `string` | `"Standard"` | no |
| vpn\_connections | VPN Connections configuration | <pre>list(object({<br>    name                      = string<br>    site_name                 = string<br>    internet_security_enabled = optional(bool)<br>    links = list(object({<br>      name                 = string,<br>      egress_nat_rule_ids  = optional(list(string))<br>      ingress_nat_rule_ids = optional(list(string))<br>      bandwidth_mbps       = optional(number)<br>      bgp_enabled          = optional(bool)<br>      connection_mode      = optional(string)<br>      ipsec_policy = optional(object({<br>        dh_group                 = string<br>        ike_encryption_algorithm = string<br>        ike_integrity_algorithm  = string<br>        encryption_algorithm     = string<br>        integrity_algorithm      = string<br>        pfs_group                = string<br>        sa_data_size_kb          = number<br>        sa_lifetime_sec          = number<br>      }))<br>      protocol                              = optional(string)<br>      ratelimit_enabled                     = optional(bool)<br>      route_weight                          = optional(number)<br>      shared_key                            = optional(string)<br>      local_azure_ip_address_enabled        = optional(bool)<br>      policy_based_traffic_selector_enabled = optional(bool)<br>    }))<br>  }))</pre> | `[]` | no |
| vpn\_encryption\_enabled | Boolean flag to specify whether VPN encryption is enabled | `bool` | `true` | no |
| vpn\_gateway\_custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| vpn\_gateway\_enabled | Enable or not the deployment of a VPN Gateway and its Connections | `bool` | `false` | no |
| vpn\_gateway\_extra\_tags | Extra tags for the VPN Gateway | `map(string)` | `null` | no |
| vpn\_gateway\_instance\_0\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the first instance | `list(string)` | `[]` | no |
| vpn\_gateway\_instance\_1\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the second instance | `list(string)` | `[]` | no |
| vpn\_gateway\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| vpn\_gateway\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| vpn\_gateway\_routing\_preference | Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet` | `string` | `"Microsoft Network"` | no |
| vpn\_gateway\_scale\_unit | The scale unit for this VPN Gateway | `number` | `1` | no |
| vpn\_sites | VPN Site configuration | <pre>list(object({<br>    name          = string,<br>    address_cidrs = optional(list(string))<br>    links = list(object({<br>      name       = string<br>      fqdn       = optional(string)<br>      ip_address = optional(string)<br>      bgp = optional(list(object({<br>        asn             = string<br>        peering_address = string<br>      })))<br>      provider_name = optional(string)<br>      speed_in_mbps = optional(string)<br>    }))<br>    device_model  = optional(string)<br>    device_vendor = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| express\_route\_circuit\_id | The ID of the ExpressRoute circuit |
| express\_route\_circuit\_service\_key | The string needed by the service provider to provision the ExpressRoute circuit |
| express\_route\_circuit\_service\_provider\_provisioning\_state | The ExpressRoute circuit provisioning state from your chosen service provider |
| express\_route\_gateway\_id | ID of the ExpressRoute gateway |
| express\_route\_peering\_azure\_asn | ASN (Autonomous System Number) Used by Azure for BGP Peering |
| firewall\_id | ID of the firewall |
| firewall\_ip\_configuration | IP configuration of the created firewall |
| firewall\_management\_ip\_configuration | Management IP configuration of the created firewall |
| firewall\_private\_ip\_address | Private IP address of the firewall |
| firewall\_public\_ip | Public IP address of the Firewall |
| virtual\_hub\_default\_route\_table\_id | ID of the default route table in the Virtual Hub |
| virtual\_hub\_id | ID of the virtual hub |
| virtual\_wan\_id | ID of the Virtual Wan |
| vpn\_gateway\_bgp\_settings | BGP Settings of the VPN Gateway |
| vpn\_gateway\_connections\_ids | List of name and IDs of VPN gateway connections |
| vpn\_gateway\_id | ID of the VPN Gateway |
<!-- END_TF_DOCS -->

## Related documentation

- Azure Virtual Wan: [docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about](https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about)
- Azure Firewall: [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
- Azure Express Route Circuit: [docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
