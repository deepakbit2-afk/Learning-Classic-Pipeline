variable "name" {
  description = "Name of the Azure Bastion host."
  type        = string
}

variable "location" {
  description = "Azure region for the Bastion host and public IP."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network containing the AzureBastionSubnet."
  type        = string
}

variable "subnet_name" {
  description = "Bastion subnet name; Azure requires AzureBastionSubnet."
  type        = string
  default     = "AzureBastionSubnet"
}

variable "public_ip_name" {
  description = "Name for the static Standard public IP used by Bastion."
  type        = string
}

variable "sku" {
  description = "Azure Bastion SKU. Bastion is a billable Azure service."
  type        = string
  default     = "Basic"
}