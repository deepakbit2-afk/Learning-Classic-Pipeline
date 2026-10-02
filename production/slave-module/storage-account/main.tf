resource "azurerm_storage_account" "main_storage_account" {
  for_each                 = var.storage_acc01
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}