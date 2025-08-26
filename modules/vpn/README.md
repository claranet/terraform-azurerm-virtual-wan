# Azure VPN

This module creates a [VPN gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/) attached to a Virtual Hub.

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
module "vpn" {
  source  = "claranet/virtual-wan/azurerm//modules/vpn"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_wan = data.azurerm_virtual_wan.main
  virtual_hub = module.virtual_hub

  instance_0_bgp_peering_address = ["169.254.21.1"]
  instance_1_bgp_peering_address = ["169.254.22.1"]

  vpn_sites = [{
    name = "site1"
    links = [
      {
        name       = "site1-primary-endpoint"
        ip_address = "20.20.20.20"
        bgp = [{
          asn             = 65530
          peering_address = "169.254.21.2"
        }]
      },
      {
        name       = "site1-secondary-endpoint"
        ip_address = "21.21.21.21"
        bgp = [{
          asn             = 65530
          peering_address = "169.254.22.2"
        }]
      },
    ]
  }]

  vpn_connections = [{
    name      = "cn-hub-to-site1"
    site_name = "site1"
    links = [
      {
        name           = "site1-primary-link"
        bandwidth_mbps = 200
        bgp_enabled    = true
        protocol       = "IKEv2"
        shared_key     = "VeryStrongSecretKeyForPrimaryLink"
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
      },
      {
        name                                  = "site1-secondary-link"
        bandwidth_mbps                        = 200
        bgp_enabled                           = true
        protocol                              = "IKEv2"
        shared_key                            = "VeryStrongSecretKeyForSecondaryLink"
        policy_based_traffic_selector_enabled = true
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
      },
    ]
    traffic_selector_policy = [{
      local_address_ranges  = ["10.0.0.0/16"],
      remote_address_ranges = ["10.92.34.50/32"]
    }]
  }]

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
| [azurerm_vpn_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) | resource |
| [azurerm_vpn_gateway_connection.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection) | resource |
| [azurerm_vpn_site.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) | resource |
| [azurecaf_name.main](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bgp\_peer\_weight | The weight added to routes learned from this BGP speaker. | `number` | `0` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom VPN gateway name. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add to the VPN gateway. | `map(string)` | `null` | no |
| instance\_0\_bgp\_peering\_address | List of custom BGP IP addresses to assign to the first instance. | `list(string)` | `[]` | no |
| instance\_1\_bgp\_peering\_address | List of custom BGP IP addresses to assign to the second instance. | `list(string)` | `[]` | no |
| internet\_security\_enabled | Enable or disable internet security for VPN connections. | `bool` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with the generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for the generated resources names. | `string` | `""` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| routing\_preference | Azure routing preference. You can choose to route traffic either via the Microsoft network (set to `Microsoft network`) or via the ISP network (set to `Internet`). | `string` | `"Microsoft Network"` | no |
| scale\_unit | The scale unit for this VPN gateway. | `number` | `1` | no |
| stack | Project Stack name. | `string` | n/a | yes |
| virtual\_hub | ID of the Virtual Hub in which to deploy the VPN gateway. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| virtual\_wan | ID of the Virtual WAN containing the Virtual Hub. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| vpn\_connections | VPN connections configuration. | <pre>list(object({<br/>    name                      = string<br/>    site_id                   = optional(string)<br/>    site_name                 = optional(string)<br/>    internet_security_enabled = optional(bool, false)<br/>    links = list(object({<br/>      name                                  = string<br/>      egress_nat_rule_ids                   = optional(list(string))<br/>      ingress_nat_rule_ids                  = optional(list(string))<br/>      bandwidth_mbps                        = optional(number, 10)<br/>      bgp_enabled                           = optional(bool, false)<br/>      connection_mode                       = optional(string, "Default")<br/>      protocol                              = optional(string, "IKEv2")<br/>      ratelimit_enabled                     = optional(bool, false)<br/>      route_weight                          = optional(number, 0)<br/>      shared_key                            = optional(string)<br/>      local_azure_ip_address_enabled        = optional(bool, false)<br/>      policy_based_traffic_selector_enabled = optional(bool, false)<br/>      ipsec_policy = optional(object({<br/>        dh_group                 = string<br/>        ike_encryption_algorithm = string<br/>        ike_integrity_algorithm  = string<br/>        encryption_algorithm     = string<br/>        integrity_algorithm      = string<br/>        pfs_group                = string<br/>        sa_data_size_kb          = number<br/>        sa_lifetime_sec          = number<br/>      }))<br/>    }))<br/>    traffic_selector_policy = optional(list(object({<br/>      local_address_ranges  = list(string)<br/>      remote_address_ranges = list(string)<br/>    })), [])<br/>    routing = optional(object({<br/>      associated_route_table = string<br/>      propagated_route_table = optional(object({<br/>        route_table_ids = list(string)<br/>        labels          = optional(list(string))<br/>      }))<br/>      inbound_route_map_id  = optional(string)<br/>      outbound_route_map_id = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| vpn\_sites | VPN sites configuration. | <pre>list(object({<br/>    name          = string<br/>    cidrs         = optional(list(string))<br/>    device_model  = optional(string)<br/>    device_vendor = optional(string)<br/>    links = list(object({<br/>      name          = string<br/>      fqdn          = optional(string)<br/>      ip_address    = optional(string)<br/>      provider_name = optional(string)<br/>      speed_in_mbps = optional(number)<br/>      bgp = optional(list(object({<br/>        asn             = string<br/>        peering_address = string<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bgp\_settings | BGP settings of the VPN gateway. |
| id | ID of the VPN gateway. |
| module\_diagnostic\_settings | Diagnostic settings module output. |
| name | Name of the VPN gateway. |
| resource | VPN gateway resource object. |
| resource\_vpn\_connection | VPN connection resource object. |
| resource\_vpn\_site | VPN site resource object. |
| vpn\_connections\_ids | Map of VPN gateway connections (name => ID). |
<!-- END_TF_DOCS -->
