# Azure Express Route
This module creates an [Express Route](https://docs.microsoft.com/en-us/azure/expressroute/) attached to a Virtual Hub.

Using this module outside the Virtual Wan module need an existing Virtual Hub.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| express\_route\_circuit\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_express_route_circuit.erc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_express_route_circuit_peering.ercprivatepeer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_express_route_gateway.ergw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) | resource |
| [azurecaf_name.azure_express_route_circuit_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.azure_express_route_gateway_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_express\_route\_circuit\_name | Custom Express Route Circuit name | `string` | `null` | no |
| custom\_express\_route\_gateway\_name | Custom Express Route Gateway name | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwith in Mbps of the ExpressRoute Circuit being created on the Service Provider | `number` | `null` | no |
| express\_route\_circuit\_peering\_location | ExpressRoute Circuit peering location. | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_peer\_asn | Peer BGP ASN for ExpressRoute Circuit Private Peering | `number` | `null` | no |
| express\_route\_circuit\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_shared\_key | Shared secret key for ExpressRoute Circuit Private Peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_vlan\_id | VLAN ID for ExpressRoute Circuit | `number` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the ExpressRoute Circuit Service Provider. | `string` | `null` | no |
| express\_route\_gateway\_scale\_unit | The number of scale unit with which to provision the ExpressRoute Gateway. | `number` | `1` | no |
| express\_route\_private\_peering\_enabled | Enable ExpressRoute Circuit Private Peering | `bool` | `false` | no |
| express\_route\_sku | ExpressRoute SKU | <pre>object({<br>    tier   = string,<br>    family = string<br>  })</pre> | <pre>{<br>  "family": "MeteredData",<br>  "tier": "Premium"<br>}</pre> | no |
| extra\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| virtual\_hub\_id | ID of the Virtual Hub in which to deploy the Firewall | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| express\_route\_circuit\_id | The ID of the ExpressRoute circuit |
| express\_route\_circuit\_service\_key | The string needed by the service provider to provision the ExpressRoute circuit |
| express\_route\_circuit\_service\_provider\_provisioning\_state | The ExpressRoute circuit provisioning state from your chosen service provider |
| express\_route\_gateway\_id | ID of the ExpressRoute gateway |
| express\_route\_peering\_azure\_asn | ASN (Autonomous System Number) Used by Azure for BGP Peering |
<!-- END_TF_DOCS -->
