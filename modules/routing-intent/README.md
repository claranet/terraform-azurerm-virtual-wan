# Routing intent

This module enables the [routing intent](https://learn.microsoft.com/en-us/azure/virtual-wan/how-to-routing-policies) feature in a Virtual Hub.

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
module "routing_intent" {
  source  = "claranet/virtual-wan/azurerm//modules/routing-intent"
  version = "x.x.x"

  virtual_hub = module.virtual_hub

  next_hop_resource_id = data.azurerm_firewall.main.id
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_hub_routing_intent.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_routing_intent) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_name | Custom routing intent name. `hubRoutingIntent` if not set. | `string` | `null` | no |
| internet\_routing\_enabled | Whether or not to enable internet routing through the next hop. | `bool` | `true` | no |
| next\_hop\_resource\_id | Resource ID of the next hop (e.g. Azure Firewall, NVA, etc.). | `string` | n/a | yes |
| private\_routing\_enabled | Whether or not to enable private routing through the next hop. | `bool` | `true` | no |
| virtual\_hub | ID of the Virtual Hub in which to enable the routing intent feature. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the routing intent. |
| name | Name of the routing intent. |
| resource | Routing intent resource object. |
<!-- END_TF_DOCS -->
