# Pre-production Terraform

`master-module` is the Terraform root. It configures AzureRM, reads deployment inputs, and calls reusable modules from `slave-module`.

## Layout

```text
Pre-production/
├── master-module/
│   ├── main.tf
│   ├── provider.tf
│   ├── variable.tf
│   └── terraform.tfvars
└── slave-module/
    ├── resource_group/
    ├── storage-account/
    ├── vnet/
    ├── subnet/
    ├── bastion/
    ├── virtual_machine/
    └── data_disk/
```

## Architecture

```text
+------------------------------------------------------------------------+

|  Azure Cloud / Subscription                                            |
|                                                                        |
|  +-----------------------------+     +-------------------------------+  |
|  | Resource Group: rg001       |     | Resource Group: rg002         |  |
|  | Region: East US             |     | Region: West US               |  |
|  |                             |     +-------------------------------+  |
|  | +-------------------------+ |                                        |
|  | | Storage: stgacc01       | |                                        |
|  | +-------------------------+ |                                        |
|  |                             |                                        |
|  | +-----------------------------------------------------------------+ |
|  | | VNet: vnet-preprod-01 (10.20.0.0/16)                            | |
|  | |                                                                 | |
|  | |  +--------------------------+     +--------------------------+  | |
|  | |  | Subnet: snet-vm-01       |     | Subnet:                  |  | |
|  | |  |                          |     | AzureBastionSubnet       |  | |
|  | |  |  +--------------------+  |     |                          |  | |
|  | |  |  | Virtual Machine    |  |     |  +--------------------+  |  | |
|  | |  |  | (Ubuntu VM)        |  |     |  | Bastion Host       |  |  | |
|  | |  |  |                    |  |     |  +----------+---------+  |  | |
|  | |  |  | [NIC] -- [NSG]  <======================/ (SSH Only)   | | |
|  | |  |  +----+---------+-----+  |     |             |            |  | |
|  | |  |       |         |        |     +-------------+------------+  | |
|  | |  |  [OS Disk]  [Data Disk]  |                   |               | |
|  | |  |              (32 GB)     |             [Public IP]           | |
|  | |  +--------------------------+                   ^               | |
|  | +-------------------------------------------------|---------------+ |
|  +---------------------------------------------------|----------------+
                                                       |
                                            (Secure Internet Access)
```

## Module Roles

| Module | Creates | Notes |
| --- | --- | --- |
| `resource_group` | `rg001`, `rg002` | East US and West US |
| `storage-account` | `stgacc01` | Located in `rg001` |
| `vnet` | `vnet-preprod-01` | Address space: `10.20.0.0/16` |
| `subnet` | `snet-vm-01`, `AzureBastionSubnet` | VM and Bastion networks |
| `bastion` | Bastion host and public IP | Private VM access |
| `virtual_machine` | Ubuntu VM, NIC, NSG, OS disk | SSH allowed from Bastion subnet |
| `data_disk` | 32-GB managed disk | Optional; attached to the VM |

The VM module reads the public key from `~/.ssh/id_ed25519.pub` by default. Set `admin_ssh_public_key_path` in `variable.tf` or provide it on the Terraform command line if the key is stored elsewhere. Keep private keys out of Terraform files.

## Initialize locally

The AzureRM backend requires Azure state settings, including a storage account,
container, and state key. When those are not available locally, initialize
without configuring the backend and validate the Terraform configuration:

```powershell
Set-Location staging/master-module
terraform init -backend=false
terraform validate
```

This local initialization does not connect to or read the shared Azure state.
Do not use it for `terraform plan` or `terraform apply`; use the pipeline, which
initializes the configured AzureRM backend, or initialize locally with the
correct backend settings before planning or applying. Review any plan before
applying. Azure Bastion, virtual machines, storage, and managed disks are
billable resources.