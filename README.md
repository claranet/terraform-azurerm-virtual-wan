# Azure Virtual Wan
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/virtual-wan/azurerm/)

Azure Virtual Wan module to create a virtual wan with one virtual hub, an Azure Firewall and an Express Route Circuit with its Private Peering

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

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"
  
  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"
  
  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "virtualwan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"
  
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
  
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  
  vhub_address_prefix = "10.10.0.0/23"
  
  enable_express_route  = true
  erc_service_provider  = "Equinix"
  erc_peering_location  = "Paris"
  erc_bandwidth_in_mbps = 100
  
  enable_er_private_peering                        = true
  erc_private_peering_primary_peer_address_prefix   = "172.32.254.0/30"
  erc_private_peering_secondary_peer_address_prefix = "172.32.254.4/30"
  erc_private_peering_vlan_id                      = 1234
  erc_private_peering_peer_asn                     = 65522
  erc_private_peering_shared_key                   = "Sup3rS3cr3tKey"
  
  logs_destinations_ids = [
    data.terraform_remote_state.shared-services.outputs["log_analytics_workspace_id"]
  ]
}
```

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

  vhub_address_prefix = var.vhub_address_prefix

  enable_firewall      = false
  enable_express_route = false

  logs_destinations_ids = [
    azurerm_log_analytics_workspace.logs.id
  ]
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
| allow\_branch\_to\_branch\_traffic | Boolean flag to specify whether branch to branch traffic is allowed | `bool` | `true` | no |
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_erc\_name | Custom express route circuit name | `string` | `null` | no |
| custom\_ergw\_name | Custom express route gateway name | `string` | `null` | no |
| custom\_fw\_name | Custom firewall's name | `string` | `null` | no |
| custom\_vhub\_name | Custom virtual hub's name | `string` | `null` | no |
| custom\_vwan\_name | Custom virtual wan's name. | `string` | `null` | no |
| disable\_vpn\_encryption | Boolean flag to specify whether VPN encryption is disabled | `bool` | `false` | no |
| enable\_er\_private\_peering | Enable Express Route Circuit Private Peering | `bool` | `false` | no |
| enable\_express\_route | Enable or not express route configuration | `bool` | `false` | no |
| enable\_firewall | Enable or not Azure Firewall in the Virtual Hub | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| er\_scale\_unit | The number of scale unit with which to provision the ExpressRoute gateway. | `number` | `1` | no |
| er\_sku | ExpressRoute SKU | <pre>object({<br>    tier   = string,<br>    family = string<br>  })</pre> | <pre>{<br>  "family": "MeteredData",<br>  "tier": "Premium"<br>}</pre> | no |
| erc\_bandwidth\_in\_mbps | The bandwith in Mbps of the circuit being created on the Service Provider | `number` | `null` | no |
| erc\_peering\_location | The name of the peering location that this Express Route is. | `string` | `null` | no |
| erc\_private\_peering\_peer\_asn | Peer BGP ASN for Express Route Circuit Private Peering | `number` | `null` | no |
| erc\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| erc\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| erc\_private\_peering\_shared\_key | Shared secret key for Express Route Circuit Private Peering | `string` | `null` | no |
| erc\_private\_peering\_vlan\_id | VLAN Id for Express Route | `number` | `null` | no |
| erc\_service\_provider | The name of the ExpressRoute Service Provider. | `string` | `null` | no |
| ergw\_exta\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| extra\_tags | Map of additional tags. | `map(string)` | `{}` | no |
| fw\_availibility\_zones | availability zones in which the Azure Firewall should be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| fw\_dns\_servers | List of DNS servers that the Azure Firewall will direct DNS traffic to for the name resolution | `list(string)` | `null` | no |
| fw\_extra\_tags | Extra tags for Firewall resource | `map(string)` | `{}` | no |
| fw\_policy\_id | ID of the Firewall Policy applied to this Firewall. | `string` | `null` | no |
| fw\_private\_ip\_ranges | List of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918 | `list(string)` | `null` | no |
| fw\_public\_ip\_count | Number of public IPs to assign to the Firewall. | `number` | `1` | no |
| fw\_sku\_tier | Sku tier of the Firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. | `list(string)` | n/a | yes |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| office365\_local\_breakout\_category | Specifies the Office365 local breakout category. Possible values include: `Optimize`, `OptimizeAndAllow`, `All`, `None` | `string` | `"None"` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| vhub\_address\_prefix | The address prefix which should be used for this virtual hub. Cannot be smaller than a /24. A /23 is recommended by Azure | `string` | n/a | yes |
| vhub\_extra\_tags | Extra tags for this virtual hub | `map(string)` | `{}` | no |
| vhub\_routes | List of route blocks. next\_hop\_ip\_address values can be azure\_firewall or an ip address | <pre>list(object({<br>    address_prefixes    = list(string),<br>    next_hop_ip_address = string<br>  }))</pre> | `[]` | no |
| vhub\_sku | The sku of the virtual hub. Possible values are `Basic` and `Standard` | `string` | `"Standard"` | no |
| vwan\_extra\_tags | Extra tags for this virtual wan | `map(string)` | `{}` | no |
| vwan\_type | Specifies the Virtual WAN type. Possible Values include: `Basic` and `Standard` | `string` | `"Standard"` | no |

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

Azure virtual wan: [docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about](https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about)
Azure firewall: [docs.microsoft.com/en-us/azure/firewall/overview](https://docs.microsoft.com/en-us/azure/firewall/overview)
Azure Express Route Circuit: [docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
