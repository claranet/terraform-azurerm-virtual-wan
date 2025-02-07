# Azure Express Route

This module creates an [Express Route](https://learn.microsoft.com/en-us/azure/expressroute/) attached to a Virtual Hub.

Use of this module outside the Virtual WAN module requires an existing Virtual Hub.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "express_route" {
  source  = "claranet/virtual-wan/azurerm//modules/express-route"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_hub = module.virtual_hub

  circuit_peering_location  = "Paris"
  circuit_bandwidth_in_mbps = 100
  circuit_service_provider  = "Equinix"

  private_peering_enabled                       = true
  private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  private_peering_shared_key                    = "MySuperSecretSharedKey"
  private_peering_peer_asn                      = 4321
  private_peering_vlan_id                       = 1234

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]

  extra_tags = var.extra_tags
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.29 |
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostic\_settings | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_express_route_circuit.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_express_route_circuit_peering.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit_peering) | resource |
| [azurerm_express_route_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) | resource |
| [azurecaf_name.circuit](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.gateway](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| circuit\_bandwidth\_in\_mbps | The bandwidth in Mbps of the Express Route circuit being created on the service provider. | `number` | n/a | yes |
| circuit\_custom\_name | Custom Express Route circuit name. | `string` | `null` | no |
| circuit\_enabled | Whether or not to create the Express Route circuit. | `bool` | `true` | no |
| circuit\_peering\_location | Express Route circuit peering location. | `string` | n/a | yes |
| circuit\_service\_provider | The name of the Express Route circuit service provider. | `string` | n/a | yes |
| circuit\_sku | Express Route circuit SKU. | <pre>object({<br/>    tier   = string<br/>    family = string<br/>  })</pre> | <pre>{<br/>  "family": "MeteredData",<br/>  "tier": "Premium"<br/>}</pre> | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add to the Express Route. | `map(string)` | `null` | no |
| gateway\_custom\_name | Custom Express Route gateway name. | `string` | `null` | no |
| gateway\_non\_virtual\_wan\_traffic\_allowed | Whether the gateway accepts traffic from non-Virtual WAN networks. | `bool` | `false` | no |
| gateway\_scale\_unit | The number of scale units with which to provision the Express Route gateway. | `number` | `1` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| private\_peering\_enabled | Whether or not to enable private peering on the Express Route circuit. | `bool` | `false` | no |
| private\_peering\_peer\_asn | Peer BGP ASN for the Express Route circuit private peering. | `number` | `null` | no |
| private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for the Express Route circuit private peering. | `string` | `null` | no |
| private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for the Express Route circuit private peering. | `string` | `null` | no |
| private\_peering\_shared\_key | Shared secret key for the Express Route circuit private peering. | `string` | `null` | no |
| private\_peering\_vlan\_id | VLAN ID for the Express Route circuit. | `number` | `null` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| stack | Project Stack name. | `string` | n/a | yes |
| virtual\_hub | ID of the Virtual Hub in which to deploy the Express Route. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| circuit\_id | The ID of the Express Route circuit. |
| circuit\_name | The name of the Express Route circuit. |
| circuit\_service\_key | The string needed by the service provider to provision the Express Route circuit. |
| circuit\_service\_provider\_provisioning\_state | The Express Route circuit provisioning state from your chosen service provider. |
| gateway\_id | The ID of the Express Route gateway. |
| gateway\_name | The name of the Express Route gateway. |
| module\_diagnostic\_settings | Diagnostic settings module output. |
| private\_peering\_azure\_asn | Autonomous System Number used by Azure for BGP peering. |
| resource\_circuit | Express Route circuit resource object. |
| resource\_circuit\_peering | Express Route circuit peering resource object. |
| resource\_gateway | Express Route gateway resource object. |
<!-- END_TF_DOCS -->
