# parent-module/main.tf
module "resource_group" {
  source = "../slave-module/resource_group"
  rg01   = var.rg01
}

module "vnet" {
  source = "../slave-module/vnet"
  vnets  = var.vnets

  depends_on = [module.resource_group]
}

module "subnet" {
  source               = "../slave-module/subnet"
  resource_group_name  = var.vnets[var.network.vnet_key].resource_group_name
  virtual_network_name = var.vnets[var.network.vnet_key].name
  subnets = {
    vm = {
      name             = var.network.vm_subnet_name
      address_prefixes = var.network.vm_subnet_address_prefixes
    }
    bastion = {
      name             = "AzureBastionSubnet"
      address_prefixes = var.network.bastion_subnet_address_prefixes
    }
  }

  depends_on = [module.vnet]
}

module "bastion" {
  source               = "../slave-module/bastion"
  name                 = var.network.bastion_name
  location             = var.vnets[var.network.vnet_key].location
  resource_group_name  = var.vnets[var.network.vnet_key].resource_group_name
  virtual_network_name = var.vnets[var.network.vnet_key].name
  public_ip_name       = var.network.bastion_public_ip_name
  sku                  = var.network.bastion_sku

  depends_on = [module.subnet]
}

module "virtual_machine" {
  source                          = "../slave-module/virtual_machine"
  resource_group_name             = var.vnets[var.network.vnet_key].resource_group_name
  location                        = var.vnets[var.network.vnet_key].location
  virtual_network_name            = var.vnets[var.network.vnet_key].name
  subnet_name                     = var.network.vm_subnet_name
  bastion_subnet_address_prefixes = var.network.bastion_subnet_address_prefixes
  admin_ssh_public_key            = trimspace(file(pathexpand(var.admin_ssh_public_key_path)))
  virtual_machines                = var.virtual_machines

  depends_on = [module.subnet]
}

module "data_disk" {
  source              = "../slave-module/data_disk"
  resource_group_name = var.vnets[var.network.vnet_key].resource_group_name
  location            = var.vnets[var.network.vnet_key].location
  data_disks          = var.data_disks

  depends_on = [module.virtual_machine]
}

module "storage_account" {
  source        = "../slave-module/storage-account"
  storage_acc01 = var.storage_acc01
  depends_on    = [module.resource_group]
}