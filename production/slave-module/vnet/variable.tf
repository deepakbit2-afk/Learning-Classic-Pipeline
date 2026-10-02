variable "vnets" {
  description = "Virtual networks to create, keyed by a stable identifier."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}