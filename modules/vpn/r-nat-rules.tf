resource "azurerm_vpn_gateway_nat_rule" "main" {
  for_each = { for k, v in var.nat_rules : v.name => v }

  name           = each.key
  vpn_gateway_id = azurerm_vpn_gateway.main.id

  mode                = each.value.mode
  type                = each.value.type
  ip_configuration_id = lower(each.value.type) == "dynamic" ? each.value.ip_configuration_instance_name : null

  dynamic "external_mapping" {
    for_each = each.value.external_mapping[*]
    content {
      address_space = external_mapping.value.address_space
      port_range    = external_mapping.value.port_range
    }
  }

  dynamic "internal_mapping" {
    for_each = each.value.internal_mapping[*]
    content {
      address_space = internal_mapping.value.address_space
      port_range    = internal_mapping.value.port_range
    }
  }
}
