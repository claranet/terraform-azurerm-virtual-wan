# Azure Virtual Hub
This module creates a Virtual Hub and attach it to an existing [Virtual Wan](https://docs.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about).

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

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

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
| azurerm | ~> 3.39 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_hub.vhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) | resource |
| [azurerm_virtual_hub_connection.peer_vnets_to_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) | resource |
| [azurecaf_name.virtual_hub](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_virtual\_hub\_name | Custom Virtual Hub's name | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| extra\_tags | Tags for this Virtual Hub | `map(string)` | `{}` | no |
| internet\_security\_enabled | Define internet security parameter in Virtual Hub Connections if set | `bool` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| peered\_virtual\_networks | Virtual Networks to peer with the Virtual Hub. | <pre>list(object({<br>    vnet_id                   = string<br>    peering_name              = optional(string)<br>    internet_security_enabled = optional(bool, true)<br><br>    routing = optional(object({<br>      associated_route_table_id = optional(string)<br><br>      propagated_route_table = optional(object({<br>        labels          = optional(list(string))<br>        route_table_ids = optional(list(string))<br>      }))<br><br>      static_vnet_route = optional(object({<br>        name                = optional(string)<br>        address_prefixes    = optional(list(string))<br>        next_hop_ip_address = optional(string)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| resource\_group\_name | Name of the application's resource group. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |
| virtual\_hub\_address\_prefix | The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure | `string` | n/a | yes |
| virtual\_hub\_routes | List of route blocks. `next_hop_ip_address` values can be `azure_firewall` or an IP address. | <pre>list(object({<br>    address_prefixes    = list(string),<br>    next_hop_ip_address = string<br>  }))</pre> | `[]` | no |
| virtual\_hub\_sku | The SKU of the Virtual Hub. Possible values are `Basic` and `Standard` | `string` | `"Standard"` | no |
| virtual\_wan\_id | ID of the Virtual Wan which host this Virtual Hub | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| virtual\_hub\_default\_route\_table\_id | ID of the default route table in the Virtual Hub |
| virtual\_hub\_id | ID of the virtual hub |
<!-- END_TF_DOCS -->
