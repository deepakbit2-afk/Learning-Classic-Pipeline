rg01 = {
  rg001 = {
    name     = "rg001"
    location = "East US"
  }
  rg002 = {
    name     = "rg002"
    location = "West US"
  }
}

storage_acc01 = {
  storage_account01 = {
    name                = "stgacc01"
    location            = "East US"
    resource_group_name = "rg001"

  }
  /*storage_account02 = {
    name                = "stgacc02"
    location            = "East US"
    resource_group_name = "rg01"
  }*/

}

vnets = {
  primary = {
    name                = "vnet-preprod-01"
    location            = "East US"
    resource_group_name = "rg001"
    address_space       = ["10.20.0.0/16"]
  }
}

network = {
  vnet_key                        = "primary"
  vm_subnet_name                  = "snet-vm-01"
  vm_subnet_address_prefixes      = ["10.20.1.0/24"]
  bastion_subnet_address_prefixes = ["10.20.255.0/26"]
  bastion_name                    = "bas-preprod-01"
  bastion_public_ip_name          = "pip-bas-preprod-01"
  bastion_sku                     = "Basic"
}

virtual_machines = {
  vm01 = {
    name           = "vm-preprod-01"
    size           = "Standard_B1s"
    admin_username = "azureuser"
  }
}

data_disks = {
  vm01_data = {
    name                 = "vm-preprod-01-data-01"
    virtual_machine_name = "vm-preprod-01"
    disk_size_gb         = 32
    storage_account_type = "StandardSSD_LRS"
    lun                  = 0
    caching              = "ReadWrite"
  }
}
