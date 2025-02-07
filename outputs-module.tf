output "terraform_module" {
  description = "Information about this Terraform module."
  value = {
    name       = "virtual-wan"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
