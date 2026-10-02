variable "storage_acc01" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}