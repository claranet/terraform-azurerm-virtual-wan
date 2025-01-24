# Azure Virtual Hub

This module creates a Virtual Hub and attach it to an existing [Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about).

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
module "virtual_hub" {
  source  = "claranet/virtual-wan/azurerm//modules/virtual-hub"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_wan = data.azurerm_virtual_wan.main

  address_prefix = "10.0.0.0/23"

  extra_tags = var.extra_tags
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.29 |
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_hub.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) | resource |
| [azurerm_virtual_hub_connection.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) | resource |
| [azurecaf_name.main](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_prefix | The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure. | `string` | n/a | yes |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom Virtual Hub name. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add to the Virtual Hub. | `map(string)` | `null` | no |
| internet\_security\_enabled | Enable or disable internet security for Virtual Hub connections. | `bool` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| peered\_virtual\_networks | List of Virtual Network objects to peer with the Virtual Hub. | <pre>list(object({<br/>    vnet_id                   = string<br/>    peering_name              = optional(string)<br/>    internet_security_enabled = optional(bool, true)<br/>    routing = optional(object({<br/>      associated_route_table_id = optional(string)<br/>      propagated_route_table = optional(object({<br/>        labels          = optional(list(string))<br/>        route_table_ids = optional(list(string))<br/>      }))<br/>      static_vnet_route = optional(object({<br/>        name                = optional(string)<br/>        address_prefixes    = optional(list(string))<br/>        next_hop_ip_address = optional(string)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| routes | List of route objects. `var.routes[*].next_hop_ip_address` values can be `azure_firewall` or an IP address. | <pre>list(object({<br/>    address_prefixes    = list(string)<br/>    next_hop_ip_address = string<br/>  }))</pre> | `[]` | no |
| sku | The SKU of the Virtual Hub. Possible values are `Basic` and `Standard`. | `string` | `"Standard"` | no |
| stack | Project Stack name. | `string` | n/a | yes |
| virtual\_wan | ID of the Virtual WAN containing this Virtual Hub. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| default\_route\_table\_id | ID of the default route table associated with the Virtual Hub. |
| id | ID of the Virtual Hub. |
| name | Name of the Virtual Hub. |
| resource | Virtual Hub resource object. |
| resource\_virtual\_hub\_connection | Virtual Hub connection resource object. |
<!-- END_TF_DOCS -->
