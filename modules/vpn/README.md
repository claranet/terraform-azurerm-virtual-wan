<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 2.90 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpn\_gateway\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.azure_vpngw_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_vpn_gateway.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) | resource |
| [azurerm_vpn_gateway_connection.vpn_gateway_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection) | resource |
| [azurerm_vpn_site.vpn_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_vpn\_gateway\_name | Custom name for the VPN Gateway | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
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
| virtual\_hub\_id | Id of the Virtual Hub in which to deploy the VPN | `string` | n/a | yes |
| virtual\_wan\_id | Id of the Virtual Wan who hosts the Virtual Hub | `string` | n/a | yes |
| vpn\_connections | VPN Connections configuration | <pre>list(object({<br>    name      = string<br>    site_name = string<br>    links = list(object({<br>      name                 = string,<br>      egress_nat_rule_ids  = optional(list(string))<br>      ingress_nat_rule_ids = optional(list(string))<br>      bandwidth_mbps       = optional(number)<br>      bgp_enabled          = optional(bool)<br>      connection_mode      = optional(string)<br>      ipsec_policy = optional(object({<br>        dh_group                 = string<br>        ike_encryption_algorithm = string<br>        ike_integrity_algorithm  = string<br>        encryption_algorithm     = string<br>        integrity_algorithm      = string<br>        pfs_group                = string<br>        sa_data_size_kb          = number<br>        sa_lifetime_sec          = number<br>      }))<br>      protocol                              = optional(string)<br>      ratelimit_enabled                     = optional(bool)<br>      route_weight                          = optional(number)<br>      shared_key                            = optional(string)<br>      local_azure_ip_address_enabled        = optional(bool)<br>      policy_based_traffic_selector_enabled = optional(bool)<br>    }))<br>  }))</pre> | `null` | no |
| vpn\_gateway\_bgp\_peer\_weight | The weight added to Routes learned from this BGP Speaker. | `number` | `0` | no |
| vpn\_gateway\_instance\_0\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the first instance | `list(string)` | `null` | no |
| vpn\_gateway\_instance\_1\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the second instance | `list(string)` | `null` | no |
| vpn\_gateway\_routing\_preference | Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet` | `string` | `"Microsoft Network"` | no |
| vpn\_gateway\_scale\_unit | The scale unit for this VPN Gateway | `number` | `1` | no |
| vpn\_gateway\_tags | Extra tags for the VPN Gateway | `map(string)` | `null` | no |
| vpn\_sites | VPN Site configuration | <pre>list(object({<br>    name          = string,<br>    address_cidrs = optional(list(string))<br>    links = list(object({<br>      name       = string<br>      fqdn       = optional(string)<br>      ip_address = optional(string)<br>      bgp = optional(list(object({<br>        asn             = string<br>        peering_address = string<br>      })))<br>      provider_name = optional(string)<br>      speed_in_mbps = optional(string)<br>    }))<br>    device_model  = optional(string)<br>    device_vendor = optional(string)<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn\_gateway\_bgp\_settings | BGP Settings of the VPN Gateway |
| vpn\_gateway\_connection\_ids | List of name and ids of vpn gateway connections |
| vpn\_gateway\_id | Id of the created vpn gateway |
<!-- END_TF_DOCS -->