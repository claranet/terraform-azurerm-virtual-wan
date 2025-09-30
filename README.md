# Azure Virtual WAN

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/virtual-wan/azurerm/)

Azure Virtual WAN module creates a Virtual WAN with a Virtual Hub, an Azure Firewall and an Express Route circuit with its private peering and VPN connections. An infrastructure example referenced in the Azure Cloud Adoption Framework is available here: [raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf](https://raw.githubusercontent.com/microsoft/CloudAdoptionFramework/master/ready/enterprise-scale-architecture.pdf)

This module use multiple sub-modules:

  * [Virtual Hub](./modules/virtual-hub/README.md): Manage all Virtual Hub configurations
  * [Azure Firewall](./modules/firewall/README.md): Manage the creation of Azure Firewall in a Secured Hub
  * [Azure ExpressRoute](./modules/express-route/README.md): Manage ExpressRoute creation and configuration
  * [Azure VPN](./modules/vpn/README.md): Manage VPN connection in a Virtual Hub

## Naming

Resource naming is based on the [Microsoft CAF naming convention best practices](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). Use the parameter `var.<resource>_custom_name` to override names.

We rely on the [forked Claranet Azure CAF naming Terraform provider](https://search.opentofu.org/provider/claranet/azurecaf/latest) to generate resources names.

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

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "virtual_wan" {
  source  = "claranet/virtual-wan/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_hub_address_prefix = "10.254.0.0/23"
  peered_virtual_networks = [
    for vnet in local.vnets : {
      vnet_id                   = module.vnets[vnet.name].id
      internet_security_enabled = vnet.internet_security_enabled
    }
  ]

  firewall_enabled                      = true
  express_route_enabled                 = true
  express_route_private_peering_enabled = true
  vpn_gateway_enabled                   = true

  express_route_circuit_peering_location  = "Paris"
  express_route_circuit_bandwidth_in_mbps = 100
  express_route_circuit_service_provider  = "Equinix"

  express_route_private_peering_primary_peer_address_prefix   = "169.254.254.0/30"
  express_route_private_peering_secondary_peer_address_prefix = "169.254.254.4/30"
  express_route_private_peering_shared_key                    = "MySuperSecretSharedKey"
  express_route_private_peering_peer_asn                      = 4321
  express_route_private_peering_vlan_id                       = 1234

  vpn_gateway_instance_0_bgp_peering_address = ["169.254.21.1"]
  vpn_gateway_instance_1_bgp_peering_address = ["169.254.22.1"]

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
        name           = "site1-secondary-link"
        bandwidth_mbps = 200
        bgp_enabled    = true
        protocol       = "IKEv2"
        shared_key     = "VeryStrongSecretKeyForSecondaryLink"
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
  }]

  logs_destinations_ids = [
    module.run.log_analytics_workspace_id,
    module.run.logs_storage_account_id,
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | >= 1.2.28 |
| azurerm | ~> 4.31 |
| terraform | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| express\_route | ./modules/express-route | n/a |
| firewall | ./modules/firewall | n/a |
| routing\_intent | ./modules/routing-intent | n/a |
| virtual\_hub | ./modules/virtual-hub | n/a |
| vpn | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_wan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) | resource |
| [terraform_data.routing_intent_precondition](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [azurecaf_name.main](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azure\_firewall\_as\_next\_hop\_enabled | Whether use Azure Firewall as next hop or a NVA. | `bool` | `true` | no |
| branch\_to\_branch\_traffic\_allowed | Boolean flag to specify whether branch to branch traffic is allowed. | `bool` | `true` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_name | Custom Virtual WAN name. | `string` | `null` | no |
| default\_tags\_enabled | Option to enabled or disable default tags | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| express\_route\_circuit\_bandwidth\_in\_mbps | The bandwidth in Mbps of the Express Route circuit being created on the service provider. | `number` | `null` | no |
| express\_route\_circuit\_custom\_name | Custom Express Route circuit name. | `string` | `null` | no |
| express\_route\_circuit\_enabled | Whether or not to create the Express Route circuit. | `bool` | `true` | no |
| express\_route\_circuit\_peering\_location | Express Route circuit peering location. | `string` | `null` | no |
| express\_route\_circuit\_service\_provider | The name of the Express Route circuit service provider. | `string` | `null` | no |
| express\_route\_circuit\_sku | Express Route circuit SKU. | <pre>object({<br/>    tier   = string<br/>    family = string<br/>  })</pre> | <pre>{<br/>  "family": "MeteredData",<br/>  "tier": "Premium"<br/>}</pre> | no |
| express\_route\_diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| express\_route\_enabled | Enable or disable Express Route. | `bool` | `false` | no |
| express\_route\_extra\_tags | Extra tags for the Express Route. | `map(string)` | `null` | no |
| express\_route\_gateway\_custom\_name | Custom Express Route gateway name. | `string` | `null` | no |
| express\_route\_gateway\_non\_virtual\_wan\_traffic\_allowed | Whether the gateway accepts traffic from non-Virtual WAN networks. | `bool` | `false` | no |
| express\_route\_gateway\_scale\_unit | The number of scale units with which to provision the Express Route gateway. | `number` | `1` | no |
| express\_route\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| express\_route\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | `null` | no |
| express\_route\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| express\_route\_private\_peering\_enabled | Whether or not to enable private peering on the Express Route circuit. | `bool` | `false` | no |
| express\_route\_private\_peering\_peer\_asn | Peer BGP ASN for the Express Route circuit private peering. | `number` | `null` | no |
| express\_route\_private\_peering\_primary\_peer\_address\_prefix | Primary peer address prefix for the Express Route circuit private peering. | `string` | `null` | no |
| express\_route\_private\_peering\_secondary\_peer\_address\_prefix | Secondary peer address prefix for the Express Route circuit private peering. | `string` | `null` | no |
| express\_route\_private\_peering\_shared\_key | Shared secret key for the Express Route circuit private peering. | `string` | `null` | no |
| express\_route\_private\_peering\_vlan\_id | VLAN ID for the Express Route circuit. | `number` | `null` | no |
| extra\_tags | Map of additional tags. | `map(string)` | `null` | no |
| firewall\_custom\_name | Custom firewall name. | `string` | `null` | no |
| firewall\_diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| firewall\_dns\_servers | List of DNS servers that the firewall will redirect DNS traffic to for the name resolution. | `list(string)` | `null` | no |
| firewall\_enabled | Enable or disable Azure Firewall in the Virtual Hub. | `bool` | `true` | no |
| firewall\_extra\_tags | Extra tags for the firewall. | `map(string)` | `null` | no |
| firewall\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| firewall\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | `null` | no |
| firewall\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| firewall\_policy | ID of the firewall policy applied to this firewall. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| firewall\_private\_ip\_ranges | List of SNAT private IP ranges, or the special string `IANAPrivateRanges`, which indicates the firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918. | `list(string)` | `null` | no |
| firewall\_public\_ip\_count | Number of public IPs to assign to the firewall. | `number` | `1` | no |
| firewall\_sku\_tier | SKU tier of the firewall. Possible values are `Premium` and `Standard`. | `string` | `"Standard"` | no |
| firewall\_zones | Availability zones in which the firewall should be created. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |
| internet\_routing\_enabled | Whether force the internet routing through Azure Firewall or the NVA. | `bool` | `true` | no |
| internet\_security\_enabled | Define internet security parameter in both VPN connections and Virtual Hub connections. | `bool` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| name\_prefix | Prefix for generated resources names. | `string` | `""` | no |
| name\_slug | Slug to use with generated resources names. | `string` | `""` | no |
| name\_suffix | Suffix for generated resources names. | `string` | `""` | no |
| nat\_rules | List of NAT rules to apply to the VPN Gateway. For dynamic NAT rules, if `ip_configuration_name` is not set, the first IP configuration will be used. | <pre>list(object({<br/>    name = string<br/>    external_mapping = list(object({<br/>      address_space = string<br/>      port_range    = optional(string)<br/>    }))<br/>    internal_mapping = list(object({<br/>      address_space = string<br/>      port_range    = optional(string)<br/>    }))<br/>    mode                           = string<br/>    type                           = optional(string, "Static")<br/>    ip_configuration_instance_name = optional(string, "Instance0")<br/>    })<br/>  )</pre> | `[]` | no |
| next\_hop\_nva\_id | ID of the NVA used as next hop. | `string` | `null` | no |
| office365\_local\_breakout\_category | Specifies the Office365 local breakout category. Possible values are `Optimize`, `OptimizeAndAllow`, `All` and `None`. Defaults to `None`. | `string` | `"None"` | no |
| peered\_virtual\_networks | List of Virtual Network objects to peer with the Virtual Hub. | <pre>list(object({<br/>    vnet_id                   = string<br/>    peering_name              = optional(string)<br/>    internet_security_enabled = optional(bool, true)<br/>    routing = optional(object({<br/>      associated_route_table_id = optional(string)<br/>      propagated_route_table = optional(object({<br/>        labels          = optional(list(string))<br/>        route_table_ids = optional(list(string))<br/>      }))<br/>      static_vnet_route = optional(object({<br/>        name                = optional(string)<br/>        address_prefixes    = optional(list(string))<br/>        next_hop_ip_address = optional(string)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| private\_routing\_enabled | Whether force the private routing through Azure Firewall or the NVA. | `bool` | `true` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| routing\_intent\_custom\_name | Custom routing intent name. `hubRoutingIntent` if not set. | `string` | `null` | no |
| routing\_intent\_enabled | Enable or disable routing intent feature in the Virtual Hub. | `bool` | `false` | no |
| stack | Project Stack name. | `string` | n/a | yes |
| type | Specifies the Virtual WAN type. Possible Values are `Basic` and `Standard`. Defaults to `Standard`. | `string` | `"Standard"` | no |
| virtual\_hub\_address\_prefix | The address prefix which should be used for this Virtual Hub. Cannot be smaller than a /24. A /23 is recommended by Azure. | `string` | n/a | yes |
| virtual\_hub\_custom\_name | Custom Virtual Hub name. | `string` | `null` | no |
| virtual\_hub\_extra\_tags | Extra tags for the Virtual Hub. | `map(string)` | `null` | no |
| virtual\_hub\_routes | List of route objects. `var.routes[*].next_hop_ip_address` values can be `azure_firewall` or an IP address. | <pre>list(object({<br/>    address_prefixes    = list(string)<br/>    next_hop_ip_address = string<br/>  }))</pre> | `[]` | no |
| virtual\_hub\_sku | The SKU of the Virtual Hub. Possible values are `Basic` and `Standard`. | `string` | `"Standard"` | no |
| virtual\_wan\_extra\_tags | Extra tags for this Virtual WAN. | `map(string)` | `null` | no |
| vpn\_connections | VPN connections configuration. | <pre>list(object({<br/>    name                      = string<br/>    site_id                   = optional(string)<br/>    site_name                 = optional(string)<br/>    internet_security_enabled = optional(bool, false)<br/>    links = list(object({<br/>      name                                  = string<br/>      egress_nat_rule_names                 = optional(list(string), [])<br/>      ingress_nat_rule_names                = optional(list(string), [])<br/>      egress_nat_rule_ids                   = optional(list(string), [])<br/>      ingress_nat_rule_ids                  = optional(list(string), [])<br/>      bandwidth_mbps                        = optional(number, 10)<br/>      bgp_enabled                           = optional(bool, false)<br/>      connection_mode                       = optional(string, "Default")<br/>      protocol                              = optional(string, "IKEv2")<br/>      ratelimit_enabled                     = optional(bool, false)<br/>      route_weight                          = optional(number, 0)<br/>      shared_key                            = optional(string)<br/>      local_azure_ip_address_enabled        = optional(bool, false)<br/>      policy_based_traffic_selector_enabled = optional(bool, false)<br/>      ipsec_policy = optional(object({<br/>        dh_group                 = string<br/>        ike_encryption_algorithm = string<br/>        ike_integrity_algorithm  = string<br/>        encryption_algorithm     = string<br/>        integrity_algorithm      = string<br/>        pfs_group                = string<br/>        sa_data_size_kb          = number<br/>        sa_lifetime_sec          = number<br/>      }))<br/>    }))<br/>    traffic_selector_policy = optional(list(object({<br/>      local_address_ranges  = list(string)<br/>      remote_address_ranges = list(string)<br/>    })), [])<br/>    routing = optional(object({<br/>      associated_route_table = string<br/>      propagated_route_table = optional(object({<br/>        route_table_ids = list(string)<br/>        labels          = optional(list(string))<br/>      }))<br/>      inbound_route_map_id  = optional(string)<br/>      outbound_route_map_id = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| vpn\_encryption\_enabled | Boolean flag to specify whether VPN encryption is enabled. | `bool` | `true` | no |
| vpn\_gateway\_bgp\_peer\_weight | The weight added to routes learned from this BGP speaker. | `number` | `0` | no |
| vpn\_gateway\_custom\_name | Custom VPN gateway name. | `string` | `null` | no |
| vpn\_gateway\_diagnostic\_settings\_custom\_name | Custom name of the diagnostic settings. Defaults to `default`. | `string` | `"default"` | no |
| vpn\_gateway\_enabled | Whether or not to enable the deployment of a VPN gateway and its connections. | `bool` | `false` | no |
| vpn\_gateway\_extra\_tags | Extra tags for the VPN gateway. | `map(string)` | `null` | no |
| vpn\_gateway\_instance\_0\_bgp\_peering\_address | List of custom BGP IP addresses to assign to the first instance. | `list(string)` | `[]` | no |
| vpn\_gateway\_instance\_1\_bgp\_peering\_address | List of custom BGP IP addresses to assign to the second instance. | `list(string)` | `[]` | no |
| vpn\_gateway\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| vpn\_gateway\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | `null` | no |
| vpn\_gateway\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| vpn\_gateway\_routing\_preference | Azure routing preference. You can choose to route traffic either via the Microsoft network (set to `Microsoft network`) or via the ISP network (set to `Internet`). | `string` | `"Microsoft Network"` | no |
| vpn\_gateway\_scale\_unit | The scale unit for this VPN gateway. | `number` | `1` | no |
| vpn\_sites | VPN sites configuration. | <pre>list(object({<br/>    name          = string<br/>    cidrs         = optional(list(string))<br/>    device_model  = optional(string)<br/>    device_vendor = optional(string)<br/>    links = list(object({<br/>      name          = string<br/>      fqdn          = optional(string)<br/>      ip_address    = optional(string)<br/>      provider_name = optional(string)<br/>      speed_in_mbps = optional(number)<br/>      bgp = optional(list(object({<br/>        asn             = string<br/>        peering_address = string<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| express\_route\_circuit\_id | ID of the Express Route circuit. |
| express\_route\_circuit\_name | Name of the Express Route circuit. |
| express\_route\_circuit\_service\_key | The string needed by the service provider to provision the Express Route circuit. |
| express\_route\_circuit\_service\_provider\_provisioning\_state | The Express Route circuit provisioning state from your chosen service provider. |
| express\_route\_gateway\_id | ID of the Express Route gateway. |
| express\_route\_gateway\_name | Name of the Express Route gateway. |
| express\_route\_private\_peering\_azure\_asn | Autonomous System Number used by Azure for BGP peering. |
| firewall\_id | ID of the firewall. |
| firewall\_ip\_configuration | IP configuration of the firewall. |
| firewall\_management\_ip\_configuration | Management IP configuration of the firewall. |
| firewall\_name | Name of the firewall. |
| firewall\_private\_ip\_address | Private IP address of the firewall. |
| firewall\_public\_ip\_addresses | Public IP addresses of the firewall. |
| id | ID of the Virtual WAN. |
| module\_express\_route | Express Route module outputs. |
| module\_firewall | Firewall module outputs. |
| module\_routing\_intent | Routing intent module outputs. |
| module\_virtual\_hub | Virtual Hub module outputs. |
| module\_vpn | VPN module outputs. |
| name | Name of the Virtual WAN. |
| resource | Virtual WAN resource object. |
| routing\_intent\_id | ID of the routing intent. |
| routing\_intent\_name | Name of the routing intent. |
| terraform\_module | Information about this Terraform module. |
| virtual\_hub\_default\_route\_table\_id | ID of the default route table associated with the Virtual Hub. |
| virtual\_hub\_id | ID of the Virtual Hub. |
| virtual\_hub\_name | Name of the Virtual Hub. |
| vpn\_gateway\_bgp\_settings | BGP settings of the VPN gateway. |
| vpn\_gateway\_connections\_ids | Map of VPN gateway connections (name => ID). |
| vpn\_gateway\_id | ID of the VPN gateway. |
| vpn\_gateway\_name | Name of the VPN gateway. |
<!-- END_TF_DOCS -->

## Related documentation

- Azure Virtual WAN: [learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about](https://learn.microsoft.com/en-us/azure/virtual-wan/virtual-wan-about)
- Azure Firewall: [learn.microsoft.com/en-us/azure/firewall/overview](https://learn.microsoft.com/en-us/azure/firewall/overview)
- Azure Express Route circuit: [learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings](https://learn.microsoft.com/en-us/azure/expressroute/expressroute-circuit-peerings)
