# Azure Virtual Wan module's example

## Quick start

To deploy and configure the Virtual Wan:

1. Modify `main.tf` to add your Azure provider credentials, etc...
2. Modify `variables.tf` to customize resources.
3. Run `terraform init` (or `tfwrapper init` using Claranet's wrapper).
4. Run `terraform apply` (or `tfwrapper apply` using Claranet's wrapper).
5. Use your virtual wan

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_network\_subnet | claranet/subnet/azurerm | x.x.x |
| azure\_region | claranet/regions/azurerm | x.x.x |
| azure\_virtual\_network | claranet/vnet/azurerm | x.x.x |
| logs | claranet/run-common/azurerm//modules/logs | x.x.x |
| rg | claranet/rg/azurerm | x.x.x |
| virtual\_wan | claranet/virtual-wan/azurerm | x.x.x |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_region | Name of the Region. | `string` | n/a | yes |
| client\_name | Name of client. | `string` | n/a | yes |
| environment | Name of application's environment. | `string` | n/a | yes |
| stack | Name of application's stack. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->