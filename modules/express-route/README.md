# Azure Express Route
This module creates an [Express Route](https://docs.microsoft.com/en-us/azure/expressroute/) attached to a Virtual Hub.

Using this module outside the Virtual Wan module need an existing Virtual Hub.

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
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

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

module "express_route" {
  source  = "claranet/virtual-wan/azurerm//modules/express-route"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id
  ]
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack
  virtual_hub_id      = module.virtual_hub.virtual_hub_id

  express_route_circuit_service_provider  = "Equinix"
  express_route_circuit_peering_location  = "Paris"
  express_route_circuit_bandwidth_in_mbps = 100

  express_route_circuit_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  express_route_circuit_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  express_route_circuit_private_peering_vlan_id                       = 1234
  express_route_circuit_private_peering_peer_asn                      = 4321
  express_route_circuit_private_peering_shared_key                    = "MySuperSecretSharedKey"
}

locals {
  tags = {
    env   = "prod"
    stack = "hub"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.48 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| express\_route\_circuit\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | ~> 7.0.0 |

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
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwidth in Mbps of the ExpressRoute Circuit being created on the Service Provider | `number` | n/a | yes |
| express\_route\_circuit\_peering\_location | ExpressRoute Circuit peering location. | `string` | n/a | yes |
| express\_route\_circuit\_private\_peering\_peer\_asn | Peer BGP ASN for ExpressRoute Circuit Private Peering | `number` | `null` | no |
| express\_route\_circuit\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for ExpressRoute Circuit private peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_shared\_key | Shared secret key for ExpressRoute Circuit Private Peering | `string` | `null` | no |
| express\_route\_circuit\_private\_peering\_vlan\_id | VLAN ID for ExpressRoute Circuit | `number` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the ExpressRoute Circuit Service Provider. | `string` | n/a | yes |
| express\_route\_gateway\_allow\_non\_virtual\_wan\_traffic | Whether the gateway accept traffic from non-Virtual WAN networks. | `bool` | `false` | no |
| express\_route\_gateway\_scale\_unit | The number of scale unit with which to provision the ExpressRoute Gateway. | `number` | `1` | no |
| express\_route\_private\_peering\_enabled | Enable ExpressRoute Circuit Private Peering | `bool` | `false` | no |
| express\_route\_sku | ExpressRoute SKU | <pre>object({<br/>    tier   = string,<br/>    family = string<br/>  })</pre> | <pre>{<br/>  "family": "MeteredData",<br/>  "tier": "Premium"<br/>}</pre> | no |
| extra\_tags | Extra tags for Express Route Gateway | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
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
