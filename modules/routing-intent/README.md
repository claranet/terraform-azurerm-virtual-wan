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

data "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  resource_group_name = var.firewall_resource_group_name
}

module "routing_intent" {
  source  = "claranet/virtual-wan/azurerm//modules/routing-intent"
  version = "x.x.x"

  next_hop_resource_id = data.azurerm_firewall.firewall.id
  virtual_hub_id       = module.virtual_hub.virtual_hub_id
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
| azurerm | ~> 3.73 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_hub_routing_intent.routing_intent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_routing_intent) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| internet\_routing\_enabled | Whether enable internet routing through this next\_hop. | `bool` | `true` | no |
| next\_hop\_resource\_id | Resource ID of the next\_hop (eg. Azure Firewall, NVA...). | `string` | n/a | yes |
| private\_routing\_enabled | Whether enable private routing through this next\_hop. | `bool` | `true` | no |
| virtual\_hub\_id | Virtual Hub ID to apply the routing intent. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
