# Azure Virtual Wan
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/virtual-wan/azurerm/)

Azure Virtual Wan module to create a virtual wan with one virtual hub, an Azure Firewall and an Express Route Circuit with its Private Peering. An infrastructure example referenced in the Azure Cloud Adoption Framework is available here: [raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf](https://raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf)

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x & 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Naming

Resource naming is based on the [Microsoft CAF naming convention best practices](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). Use the parameter `custom_<resource>_name` to override names.
We rely on [the official Terraform Azure CAF naming provider](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) to generate resource names.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
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
      vnet_name = "MyVnet1"
      vnet_cidr = "10.10.0.0/16"
    },
    {
      vnet_name = "MyVnet2"
      vnet_cidr = "10.100.0.0/16"
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

  custom_vnet_name = "MyVnet"
  vnet_cidr        = ["10.10.0.0/16"]
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
  subnet_cidr_list     = each.value

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


resource "azurerm_virtual_hub_connection" "peer_vnet_to_hub" {
  for_each                  = { for vnet in local.vnets : vnet.vnet_name => vnet }
  name                      = "${module.azure_virtual_network[each.key].virtual_network_name}-to-hub"
  remote_virtual_network_id = module.azure_virtual_network[each.key].virtual_network_id
  virtual_hub_id            = module.virtual_wan.virtual_hub_id
}

```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | >= 2.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics\_settings | claranet/diagnostic-settings/azurerm | 4.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_express_route_circuit.erc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_express_route_circuit_peering.ercprivatepeer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_express_route_gateway.ergw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) | resource |
| [azurerm_firewall.azfw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_virtual_hub.vhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) | resource |
| [azurerm_virtual_wan.vwan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) | resource |
| [azurerm_resources.resources](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| branch\_to\_branch\_traffic\_allowed | Boolean flag to specify whether branch to branch traffic is allowed | `bool` | `true` | no |
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_express\_route\_circuit\_name | Custom express route circuit name | `string` | `null` | no |
| custom\_express\_route\_gateway\_name | Custom express route gateway name | `string` | `null` | no |
| custom\_firewall\_name | Custom firewall's name | `string` | `null` | no |
| custom\_virtual\_hub\_name | Custom virtual hub's name | `string` | `null` | no |
| custom\_vwan\_name | Custom virtual wan's name. | `string` | `null` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwith in Mbps of the circuit being created on the Service Provider | `number` | `null` | no |
| express\_route\_circuit\_peering\_location | Express route peering location. | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_peer\_asn | Peer BGP ASN for Express Route Circuit Private Peering | `number` | `null` | no |
| express\_route\_circuit\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_shared\_key | Shared secret key for Express Route Circuit Private Peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_vlan\_id | VLAN Id for Express Route | `number` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the ExpressRoute Service Provider. | `string` | `null` | no |
| express\_route\_enabled | Enable or not express route configuration | `bool` | `false` | no |
| express\_route\_gateway\_exta\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| express\_route\_gateway\_scale\_unit | The number of scale unit with which to provision the ExpressRoute gateway. | `number` | `1` | no |
| express\_route\_private\_peering\_enabled | Enable Express Route Circuit Private Peering | `bool` | `false` | no |
| express\_route\_sku | ExpressRoute SKU | <pre>object({<br>    tier   = string,<br>    family = string<br>  })</pre> | <pre>{<br>  "family": "MeteredData",<br>  "tier": "Premium"<br>}</pre> | no |
| extra\_tags | Map of additional tags. | `map(string)` | `{}` | no |
| firewall\_availibility\_zones | availability zones in which the Azure Firewall should be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| firewall\_dns\_servers | List of DNS servers that the Azure Firewall will direct DNS traffic to for the name resolution | `list(string)` | `null` | no |
| firewall\_enabled | Enable or not Azure Firewall in the Virtual Hub | `bool` | `true` | no |
| firewall\_extra\_tags | Extra tags for Firewall resource | `map(string)` | `{}` | no |
| firewall\_policy\_id | ID of the Firewall Policy applied to this Firewall. | `string` | `null` | no |
| firewall\_private\_ip\_ranges | List of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918 | `list(string)` | `null` | no |
| firewall\_public\_ip\_count | Number of public IPs to assign to the Firewall. | `number` | `1` | no |
| firewall\_sku\_tier | Sku tier of the Firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. | `list(string)` | n/a | yes |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| office365\_local\_breakout\_category | Specifies the Office365 local breakout category. Possible values include: `Optimize`, `OptimizeAndAllow`, `All`, `None` | `string` | `"None"` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| virtual\_hub\_address\_prefix | The address prefix which should be used for this virtual hub. Cannot be smaller than a /24. A /23 is recommended by Azure | `string` | n/a | yes |
| virtual\_hub\_extra\_tags | Extra tags for this virtual hub | `map(string)` | `{}` | no |
| virtual\_hub\_routes | List of route blocks. next\_hop\_ip\_address values can be azure\_firewall or an ip address | <pre>list(object({<br>    address_prefixes    = list(string),<br>    next_hop_ip_address = string<br>  }))</pre> | `[]` | no |
| virtual\_hub\_sku | The sku of the virtual hub. Possible values are `Basic` and `Standard` | `string` | `"Standard"` | no |
| virtual\_wan\_extra\_tags | Extra tags for this virtual wan | `map(string)` | `{}` | no |
| virtual\_wan\_type | Specifies the Virtual WAN type. Possible Values include: `Basic` and `Standard` | `string` | `"Standard"` | no |
| vpn\_encryption\_enabled | Boolean flag to specify whether VPN encryption is enabled | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| express\_route\_circuit\_id | The ID of the ExpressRoute circuit |
| express\_route\_circuit\_service\_key | The string needed by the service provider to provision the ExressRoute circuit |
| express\_route\_circuit\_service\_provider\_provisioning\_state | The ExpressRoute circuit provisioning state from your chosen service provider |
| express\_route\_gateway\_id | Id of the ExpressRoute gateway |
| express\_route\_peering\_azure\_asn | ASN (Autonomous System Number) Used by Azure for BGP Peering |
| firewall\_id | Id of the firewall |
| firewall\_private\_ip\_address | Private IP address of the firewall |
| firewall\_public\_ip | Public IP address of the Firewall |
| virtual\_hub\_id | Id of the virtual hub |
<!-- END_TF_DOCS -->

## Related documentation

- Azure virtual wan: [docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about](https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about)
- Azure firewall: [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
- Azure Express Route Circuit: [docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
