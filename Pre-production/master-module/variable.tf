variable "rg01" {
  type = map(object({
    name     = string
    location = string
  }))
}
variable "storage_acc01" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "vnets" {
  description = "Virtual networks keyed by stable identifiers."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}

variable "network" {
  description = "Selects a VNet for its VM subnet and Bastion settings."
  type = object({
    vnet_key                        = string
    vm_subnet_name                  = string
    vm_subnet_address_prefixes      = list(string)
    bastion_subnet_address_prefixes = list(string)
    bastion_name                    = string
    bastion_public_ip_name          = string
    bastion_sku                     = string
  })
}

variable "admin_ssh_public_key_path" {
  description = "Path to the public SSH key installed on the Linux virtual machines."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "virtual_machines" {
  description = "Linux virtual machines to create, keyed by a stable identifier."
  type = map(object({
    name           = string
    size           = string
    admin_username = string
  }))
}

variable "data_disks" {
  description = "Optional managed data disks attached to Linux virtual machines."
  type = map(object({
    name                 = string
    virtual_machine_name = string
    disk_size_gb         = number
    storage_account_type = string
    lun                  = number
    caching              = string
  }))
}