## 7.8.2 (2024-10-17)

### Bug Fixes

* **AZ-1430:** handling case diff in name 2bf3e70

### Miscellaneous Chores

* **deps:** update dependency pre-commit to v4.0.1 10d6b7d
* **deps:** update dependency trivy to v0.56.2 55d0afd
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 07cf483
* update examples structure 7e1b96f

## 7.8.1 (2024-10-08)

### Documentation

* update submodule README with `terraform-docs` v0.19.0 d9e0d16

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 47d7f01
* **deps:** update dependency opentofu to v1.8.3 23a7fbb
* **deps:** update dependency pre-commit to v4 52fea66
* **deps:** update dependency trivy to v0.56.1 45d847a
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 d564b32
* prepare for new examples structure 02084de

## 7.8.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 557f708

### Documentation

* update README badge to use OpenTofu registry b96e5b0
* update README with `terraform-docs` v0.19.0 7e08dc5
* update submodule README with `terraform-docs` v0.19.0 1a811ba

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.2 8f48825
* **deps:** update dependency terraform-docs to v0.19.0 8d47c01
* **deps:** update dependency trivy to v0.55.0 7de6d67
* **deps:** update dependency trivy to v0.55.1 804b3b7
* **deps:** update dependency trivy to v0.55.2 87e43b6
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 1396af3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 6e50e33
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 a29f5c7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 cb51172
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 145189b
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 5628bf6
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 b58d612

## 7.7.1 (2024-08-30)

### Bug Fixes

* remove lookup in VPN module and fix lint 75844fd

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.1 525835c
* **deps:** update dependency pre-commit to v3.8.0 4867750
* **deps:** update dependency trivy to v0.54.1 d006d49
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 6983e8b
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 f6bada9
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 2793045
* **deps:** update tools 5131440
* **deps:** update tools 1b54dfc

## 7.7.0 (2024-07-12)


### Features

* add in `express_route` module, `allow_non_virtual_wan_traffic` parameter 27ae368


### Documentation

* update variable descriptions c309f5c


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] a75b1b2
* **AZ-1391:** update semantic-release config [skip ci] 8a70548


### Miscellaneous Chores

* **deps:** add renovate.json 7890152
* **deps:** enable automerge on renovate 027ecf2
* **deps:** update dependency opentofu to v1.7.0 9c2166b
* **deps:** update dependency opentofu to v1.7.1 94e334b
* **deps:** update dependency opentofu to v1.7.2 872b093
* **deps:** update dependency opentofu to v1.7.3 99762ec
* **deps:** update dependency pre-commit to v3.7.1 e1fedc1
* **deps:** update dependency terraform-docs to v0.18.0 080e517
* **deps:** update dependency tflint to v0.51.0 448bd26
* **deps:** update dependency tflint to v0.51.1 06cac5c
* **deps:** update dependency tflint to v0.51.2 17e83e0
* **deps:** update dependency tflint to v0.52.0 9f11f2d
* **deps:** update dependency trivy to v0.50.2 518a8d3
* **deps:** update dependency trivy to v0.50.4 0e4b7f2
* **deps:** update dependency trivy to v0.51.0 4e96fd1
* **deps:** update dependency trivy to v0.51.1 956343d
* **deps:** update dependency trivy to v0.51.2 d7539fd
* **deps:** update dependency trivy to v0.51.4 8cf51f2
* **deps:** update dependency trivy to v0.52.0 8b8e40a
* **deps:** update dependency trivy to v0.52.1 ed3d50f
* **deps:** update dependency trivy to v0.52.2 ab03eeb
* **deps:** update dependency trivy to v0.53.0 08fe81d
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 8087b49
* **deps:** update renovate.json 666d867
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 6.5.0 3a7c8b2
* **pre-commit:** update commitlint hook df269a7
* **release:** remove legacy `VERSION` file a4dd8e4

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
