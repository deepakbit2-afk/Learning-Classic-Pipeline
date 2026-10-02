variable "resource_group_name" {
  description = "Existing resource group for the virtual machines."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual machines and network interfaces."
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network containing the VM subnet."
  type        = string
}

variable "subnet_name" {
  description = "Existing subnet where the VM network interfaces will be placed."
  type        = string
}

variable "bastion_subnet_address_prefixes" {
  description = "Address prefixes allowed to SSH to VMs through Azure Bastion."
  type        = list(string)
}

variable "admin_ssh_public_key" {
  description = "Public SSH key installed on the Linux VMs."
  type        = string

  validation {
    condition     = trimspace(var.admin_ssh_public_key) != ""
    error_message = "Provide an SSH public key; password authentication is disabled."
  }
}

variable "virtual_machines" {
  description = "Linux virtual machines to create, keyed by a stable identifier."
  type = map(object({
    name           = string
    size           = string
    admin_username = string
  }))
}