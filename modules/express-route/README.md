# Azure Express Route
This module creates an Express Route attached to a Virtual Hub.
Using this module outside the Virtual Wan module need an existing Virtual Hub.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 2.90 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| express\_route\_circuit\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.azure_express_route_circuit_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azure_express_route_gateway_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_express_route_circuit.erc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_express_route_circuit_peering.ercprivatepeer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_express_route_gateway.ergw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_express\_route\_circuit\_name | Custom Express Route Circuit name | `string` | `null` | no |
| custom\_express\_route\_gateway\_name | Custom Express Route Gateway name | `string` | `null` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwith in Mbps of the Express Route Circuit being created on the Service Provider | `number` | `null` | no |
| express\_route\_circuit\_peering\_location | Express Route Circuit peering location. | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_peer\_asn | Peer BGP ASN for Express Route Circuit Private Peering | `number` | `null` | no |
| express\_route\_circuit\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for Express Route Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_shared\_key | Shared secret key for Express Route Circuit Private Peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_vlan\_id | VLAN Id for Express Route Circuit | `number` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the Express Route Circuit Service Provider. | `string` | `null` | no |
| express\_route\_gateway\_scale\_unit | The number of scale unit with which to provision the Express Route Gateway. | `number` | `1` | no |
| express\_route\_gateway\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| express\_route\_private\_peering\_enabled | Enable Express Route Circuit Private Peering | `bool` | `false` | no |
| express\_route\_sku | Express Route SKU | <pre>object({<br>    tier   = string,<br>    family = string<br>  })</pre> | <pre>{<br>  "family": "MeteredData",<br>  "tier": "Premium"<br>}</pre> | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| virtual\_hub\_id | Id of the Virtual Hub in which to deploy the Firewall | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| express\_route\_circuit\_id | The ID of the ExpressRoute circuit |
| express\_route\_circuit\_service\_key | The string needed by the service provider to provision the ExressRoute circuit |
| express\_route\_circuit\_service\_provider\_provisioning\_state | The ExpressRoute circuit provisioning state from your chosen service provider |
| express\_route\_gateway\_id | Id of the ExpressRoute gateway |
| express\_route\_peering\_azure\_asn | ASN (Autonomous System Number) Used by Azure for BGP Peering |
<!-- END_TF_DOCS -->
