variable "resource_group_name" {
  description = "Existing resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the existing virtual network for these subnets."
  type        = string
}

variable "subnets" {
  description = "Subnets to create, keyed by a stable identifier."
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}