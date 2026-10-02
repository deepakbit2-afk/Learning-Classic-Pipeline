resource "azurerm_resource_group" "main_rg" {
  for_each = var.rg01
  name     = each.value.name
  location = each.value.location
}