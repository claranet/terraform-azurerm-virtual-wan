# Azure Firewall
This module creates an [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/) attached to a Virtual Hub.

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
| firewall\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.azfw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurecaf_name.azure_firewall_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_name | Custom Firewall's name | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| extra\_tags | Tags for Firewall resource | `map(string)` | `{}` | no |
| firewall\_availibility\_zones | Availability zones in which the Azure Firewall should be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| firewall\_dns\_servers | List of DNS servers that the Azure Firewall will direct DNS traffic to for the name resolution | `list(string)` | `null` | no |
| firewall\_policy\_id | ID of the Firewall Policy applied to this Firewall. | `string` | `null` | no |
| firewall\_private\_ip\_ranges | List of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918 | `list(string)` | `null` | no |
| firewall\_public\_ip\_count | Number of public IPs to assign to the Firewall. | `number` | `1` | no |
| firewall\_sku\_tier | SKU tier of the Firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
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
| firewall\_id | ID of the created firewall |
| firewall\_ip\_configuration | IP configuration of the created firewall |
| firewall\_management\_ip\_configuration | Management IP configuration of the created firewall |
| firewall\_private\_ip\_address | Private IP address of the firewall |
| firewall\_public\_ip | Public IP address of the firewall |
<!-- END_TF_DOCS -->
