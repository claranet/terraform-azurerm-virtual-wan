# Azure VPN

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

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
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

module "vpn" {
  source  = "claranet/virtual-wan/azurerm//modules/vpn"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
  ]

  virtual_wan_id = data.azurerm_virtual_wan.virtual_wan.id
  virtual_hub_id = module.virtual_hub.virtual_hub_id

  vpn_gateway_instance_0_bgp_peering_address = ["169.254.21.1"]
  vpn_gateway_instance_1_bgp_peering_address = ["169.254.22.1"]

  vpn_sites = [
    {
      name = "site1"
      links = [
        {
          name       = "site1-primary-endpoint"
          ip_address = "20.20.20.20"
          bgp = [
            {
              asn             = 65530
              peering_address = "169.254.21.2"
            }
          ]
        },
        {
          name       = "site1-secondary-endpoint"
          ip_address = "21.21.21.21"
          bgp = [
            {
              asn             = 65530
              peering_address = "169.254.22.2"
            }
          ]
        }
      ]
    }
  ]

  vpn_connections = [
    {
      name      = "cn-hub-to-site1"
      site_name = "site1"
      links = [
        {
          name           = "site1-primary-link"
          bandwidth_mbps = 200
          bgp_enabled    = true
          ipsec_policy = {
            dh_group                 = "DHGroup14"
            ike_encryption_algorithm = "AES256"
            ike_integrity_algorithm  = "SHA256"
            encryption_algorithm     = "AES256"
            integrity_algorithm      = "SHA256"
            pfs_group                = "PFS14"
            sa_data_size_kb          = 102400000
            sa_lifetime_sec          = 3600
          }
          protocol   = "IKEv2"
          shared_key = "VeryStrongSecretKeyForPrimaryLink"
        },
        {
          name           = "site1-secondary-link"
          bandwidth_mbps = 200
          bgp_enabled    = true
          ipsec_policy = {
            dh_group                 = "DHGroup14"
            ike_encryption_algorithm = "AES256"
            ike_integrity_algorithm  = "SHA256"
            encryption_algorithm     = "AES256"
            integrity_algorithm      = "SHA256"
            pfs_group                = "PFS14"
            sa_data_size_kb          = 102400000
            sa_lifetime_sec          = 3600
          }
          protocol                              = "IKEv2"
          shared_key                            = "VeryStrongSecretKeyForSecondaryLink"
          policy_based_traffic_selector_enabled = true
        }
      ]
      traffic_selector_policy = [
        {
          local_address_ranges  = ["10.0.0.0/16"],
          remote_address_ranges = ["10.92.34.50/32"]
        }
      ]
    }
  ]
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

| Name | Source | Version |
|------|--------|---------|
| vpn\_gateway\_diagnostic\_settings | claranet/diagnostic-settings/azurerm | ~> 7.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_vpn_gateway.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) | resource |
| [azurerm_vpn_gateway_connection.vpn_gateway_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection) | resource |
| [azurerm_vpn_site.vpn_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) | resource |
| [azurecaf_name.azure_vpngw_caf](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Name of client. | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_name | Custom name for the VPN Gateway | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Name of application's environment. | `string` | n/a | yes |
| extra\_tags | Extra tags for the VPN Gateway | `map(string)` | `null` | no |
| internet\_security\_enabled | Define internet security parameter in VPN Connections if set | `bool` | `null` | no |
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
| virtual\_hub\_id | ID of the Virtual Hub in which to deploy the VPN | `string` | n/a | yes |
| virtual\_wan\_id | ID of the Virtual Wan who hosts the Virtual Hub | `string` | n/a | yes |
| vpn\_connections | VPN Connections configuration | <pre>list(object({<br/>    name                      = string<br/>    site_name                 = optional(string)<br/>    site_id                   = optional(string)<br/>    internet_security_enabled = optional(bool, false)<br/>    links = list(object({<br/>      name                 = string<br/>      egress_nat_rule_ids  = optional(list(string), [])<br/>      ingress_nat_rule_ids = optional(list(string), [])<br/>      bandwidth_mbps       = optional(number, 10)<br/>      bgp_enabled          = optional(bool, false)<br/>      connection_mode      = optional(string, "Default")<br/>      ipsec_policy = optional(object({<br/>        dh_group                 = string<br/>        ike_encryption_algorithm = string<br/>        ike_integrity_algorithm  = string<br/>        encryption_algorithm     = string<br/>        integrity_algorithm      = string<br/>        pfs_group                = string<br/>        sa_data_size_kb          = number<br/>        sa_lifetime_sec          = number<br/>      }))<br/>      protocol                              = optional(string, "IKEv2")<br/>      ratelimit_enabled                     = optional(bool, false)<br/>      route_weight                          = optional(number, 0)<br/>      shared_key                            = optional(string, null)<br/>      local_azure_ip_address_enabled        = optional(bool, false)<br/>      policy_based_traffic_selector_enabled = optional(bool, false)<br/>    }))<br/>    traffic_selector_policy = optional(list(object({<br/>      local_address_ranges  = list(string)<br/>      remote_address_ranges = list(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| vpn\_gateway\_bgp\_peer\_weight | The weight added to Routes learned from this BGP Speaker. | `number` | `0` | no |
| vpn\_gateway\_instance\_0\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the first instance | `list(string)` | `null` | no |
| vpn\_gateway\_instance\_1\_bgp\_peering\_address | List of custom BGP IP Addresses to assign to the second instance | `list(string)` | `null` | no |
| vpn\_gateway\_routing\_preference | Azure routing preference. Tou can choose to route traffic either via `Microsoft network` or via the ISP network through public `Internet` | `string` | `"Microsoft Network"` | no |
| vpn\_gateway\_scale\_unit | The scale unit for this VPN Gateway | `number` | `1` | no |
| vpn\_sites | VPN Site configuration | <pre>list(object({<br/>    name          = string,<br/>    address_cidrs = optional(list(string), [])<br/>    links = list(object({<br/>      name       = string<br/>      fqdn       = optional(string)<br/>      ip_address = optional(string)<br/>      bgp = optional(list(object({<br/>        asn             = string<br/>        peering_address = string<br/>      })), [])<br/>      provider_name = optional(string)<br/>      speed_in_mbps = optional(string)<br/>    }))<br/>    device_model  = optional(string)<br/>    device_vendor = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn\_gateway\_bgp\_settings | BGP settings of the VPN Gateway |
| vpn\_gateway\_connection\_ids | List of name and IDs of VPN gateway connections |
| vpn\_gateway\_id | ID of the created VPN gateway |
<!-- END_TF_DOCS -->
