# Azure Firewall

This module creates an [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/) attached to a Virtual Hub.

Using this module outside the Virtual WAN module requires an existing Virtual Hub.

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
module "firewall" {
  source  = "claranet/virtual-wan/azurerm//modules/firewall"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_hub = module.virtual_hub

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
| diagnostic\_settings | claranet/diagnostic-settings/azurerm | ~> 8.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurecaf_name.main](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom firewall name. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| dns\_servers | List of DNS servers that the firewall will redirect DNS traffic to for the name resolution. | `list(string)` | `null` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add to the firewall. | `map(string)` | `null` | no |
| firewall\_policy | ID of the firewall policy applied to this firewall. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| private\_ip\_ranges | List of SNAT private IP ranges, or the special string `IANAPrivateRanges`, which indicates the firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| public\_ip\_count | Number of public IPs to assign to the firewall. | `number` | `1` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| sku\_tier | SKU tier of the firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| stack | Project Stack name. | `string` | n/a | yes |
| virtual\_hub | ID of the Virtual Hub in which to deploy the firewall. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| zones | Availability zones in which the firewall should be created. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the firewall. |
| ip\_configuration | IP configuration of the firewall. |
| management\_ip\_configuration | Management IP configuration of the firewall. |
| module\_diagnostic\_settings | Diagnostic settings module output. |
| name | Name of the firewall. |
| private\_ip\_address | Private IP address of the firewall. |
| public\_ip\_addresses | Public IP addresses of the firewall. |
| resource | Firewall resource object. |
<!-- END_TF_DOCS -->
