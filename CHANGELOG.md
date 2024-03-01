# v7.6.1 - 2024-03-01

Fixed
  * AZ-1352: Fixed a `null` error when BGP was not used

# v7.6.0 - 2023-09-22

Changed
  * AZ-1177: Use new resource `azurerm_virtual_hub_routing_intent` in submodule

# v7.5.0 - 2023-06-23

Added
  * AZ-1091: Add routing intent configuration

# v7.4.0 - 2023-05-26

Added
  * AZ-1041: Add `traffic_selector_policy` option for VPN connections

# v7.3.1 - 2023-05-05

Fixed
  * AZ-1075: Fix mandatory variables

# v7.3.0 - 2023-02-10

Added
  * AZ-994: Add `logs_destinations_ids` per resource

Changed
  * AZ-994: Bump `diagnostic-settings` to `~> 6.3.0`

# v7.2.0 - 2022-12-02

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

Added
  * AZ-908: Implement CAF naming for Virtual Hub module

# v7.1.0 - 2022-10-28

Changed
  * AZ-871: Implement all available options for VHub <> VNet peering, `peered_virtual_networks` is now a typed list(object)

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `v1.3`

# v6.1.0 - 2022-08-19

Fixed
  * AZ-803 Fix crash when ExpressRoute is created without a Circuit.

Added
  * AZ-824: Add `internet_security_enabled` new parameter option

# v6.0.0 - 2022-05-16

Breaking
  * AZ-717 Bump to AzureRM v3.0

# v5.1.0 - 2022-05-13

Fixed
  * AZ-709 Fix issue on diagnostic settings `for_each` value that depends on resource attributes that cannot be determined until apply

Breaking
  * AZ-715 Split sub-resources into sub-modules

Added
  * AZ-713 Add `virtual_wan_id` output
  * AZ-712 Allow the creation of `azurerm_vpn_gateway`, `azurerm_vpn_site` and `azurerm_vpn_gateway_connection` in Virtual Wan
  * AZ-715 Bump diagnostic-settings module to `v5.0.0`
  * AZ-615 Add an option to enable or disable default tags

# v5.0.1 - 2021-12-28

Fixed
  * AZ-624: Fix bug when ipGroup is created, the module tries to apply diagnostic settings on it. But ipGroup does not support diagnostic settings

Added
  * AZ-624: Bump diagnostic-settings module to `v4.0.3`

# v5.0.0 - 2021-11-23

Added
  *  AZ-559: Create virtual wan module
