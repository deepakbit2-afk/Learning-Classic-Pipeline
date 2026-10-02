variable "resource_group_name" {
  description = "Existing resource group containing the Linux virtual machines."
  type        = string
}

variable "location" {
  description = "Azure region for the managed data disks."
  type        = string
}

variable "data_disks" {
  description = "Managed data disks to create and attach, keyed by a stable identifier."
  type = map(object({
    name                 = string
    virtual_machine_name = string
    disk_size_gb         = number
    storage_account_type = string
    lun                  = number
    caching              = string
  }))
}