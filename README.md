# Azure VNet Peering with Bastion Host

Terraform project that provisions a **hub-and-spoke** network topology on Azure with **bidirectional VNet peering**, **Linux virtual machines**, and an **Azure Bastion** jump-box for secure SSH access -- all managed as Infrastructure as Code.

---

## Architecture

```
                    +----------------------------------------------+
                    |            Azure Resource Group               |
                    |                 (Vpr-rg)                      |
                    |                                               |
                    |  +------------------+  +------------------+   |
                    |  |   VNet1 (Hub)    |  |  VNet2 (Spoke)   |   |
                    |  |  10.0.0.0/16     |  |  20.0.0.0/16     |   |
                    |  |                  |  |                  |   |
                    |  |  +------------+  |  |  +------------+  |   |
                    |  |  |  subnet1   |  |  |  |  subnet2   |  |   |
                    |  |  | 10.0.0.0/24|  |  |  | 20.0.0.0/24|  |   |
                    |  |  |    [vm1]   |  |  |  |    [vm2]   |  |   |
                    |  |  +------------+  |  |  +------------+  |   |
                    |  |                  |<-+->                |   |
                    |  |  +------------+  |  |   VNet Peering   |   |
                    |  |  |  Bastion   |  |  |  (Bidirectional) |   |
                    |  |  |  Subnet    |  |  |                  |   |
                    |  |  | 10.0.1.0/26|  |  |                  |   |
                    |  |  +-----+------+  |  |                  |   |
                    |  +--------+------ --+  +------------------+   |
                    |           |                                    |
                    |    +------+--------+                          |
                    |    | Bastion Host  |                          |
                    |    |  (Public IP)  |                          |
                    |    +------+--------+                          |
                    +-----------+----------------------------------+
                                |
                           Internet
```

## Resources Provisioned

| Resource | Type | Purpose |
|---|---|---|
| Resource Group | `azurerm_resource_group` | Logical container for all resources |
| VNet 1 (Hub) | `azurerm_virtual_network` | Hub network `10.0.0.0/16` |
| VNet 2 (Spoke) | `azurerm_virtual_network` | Spoke network `20.0.0.0/16` |
| Subnet 1 | `azurerm_subnet` | VM subnet in hub `10.0.0.0/24` |
| Subnet 2 | `azurerm_subnet` | VM subnet in spoke `20.0.0.0/24` |
| Bastion Subnet | `azurerm_subnet` | `AzureBastionSubnet` `10.0.1.0/26` |
| VNet Peering (x2) | `azurerm_virtual_network_peering` | Bidirectional peering hub to spoke |
| NIC 1 / NIC 2 | `azurerm_network_interface` | Network interfaces for each VM |
| VM 1 / VM 2 | `azurerm_linux_virtual_machine` | Ubuntu 22.04 LTS `Standard_B2as_v2` |
| Public IP | `azurerm_public_ip` | Static Standard-SKU IP for Bastion |
| Bastion Host | `azurerm_bastion_host` | Secure browser-based SSH access to VMs |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.50
- An active Azure subscription
- An SSH key pair (default path: `~/.ssh/id_ed25519`)

### Authenticate

```bash
az login
az account set --subscription "your-subscription-id"
```

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/your-username/Terraform-Vnet-Peering.git
cd Terraform-Vnet-Peering

# 2. Review and edit variables
vi Terraform.tfvars

# 3. Initialise (backend + providers)
terraform init

# 4. Preview changes
terraform plan

# 5. Apply
terraform apply
```

---

## Project Structure

```
Terraform-Vnet-Peering/
+-- Backend.tf           # Azure Storage remote state backend
+-- provider.tf          # AzureRM provider and Terraform version constraints
+-- input.tf             # Variable declarations
+-- Terraform.tfvars     # Variable values (edit to customise)
+-- vnet.tf              # VNets, subnets, and VNet peering
+-- vm.tf                # NICs, Linux VMs, Bastion host and public IP
+-- output.tf            # Terraform outputs
+-- README.md
```

---

## Input Variables

| Variable | Type | Description | Default |
|---|---|---|---|
| `vpr` | `string` | Project prefix used for resource group naming | -- |
| `location` | `string` | Azure region for all resources | -- |
| `vnet1` | `string` | Name of the hub VNet | -- |
| `vnet2` | `string` | Name of the spoke VNet | -- |
| `subnet1` | `string` | Name of the hub subnet | -- |
| `subnet2` | `string` | Name of the spoke subnet | -- |
| `vm1-nic` | `string` | Name of VM 1 network interface | -- |
| `vm2-nic` | `string` | Name of VM 2 network interface | -- |
| `vm1-name` | `string` | Name of VM 1 | -- |
| `vm2-name` | `string` | Name of VM 2 | -- |
| `compute-size` | `string` | Azure VM SKU size | -- |
| `env` | `list` | Environment tags for each VM | `["dev", "stage"]` |
| `admin-username` | `string` | SSH admin username for the VMs | -- |
| `bastion-box-name` | `string` | Name of the Bastion host | -- |
| `bastion_ip_name` | `string` | Name of the Bastion public IP | -- |
| `path` | `string` | Local path to the SSH public key file | -- |

## Outputs

| Output | Description |
|---|---|
| `bastion_ip` | Public IP address of the Azure Bastion host |

---

## Remote State Backend

State is stored in an **Azure Storage Account** configured in [Backend.tf](Backend.tf):

| Setting | Value |
|---|---|
| Resource Group | `rg-tfstate` |
| Storage Account | `sttfstate2298121177` |
| Container | `tfstate` |
| Key | `project/terraform.tfstate` |

> **Note:** The storage account and container must exist before running `terraform init`.

---

## Connecting to VMs

Both VMs are private (no public IPs). Connect via Azure Bastion from the Azure Portal:

1. Navigate to **Virtual Machines** and select `vm1` or `vm2`.
2. Click **Connect** and then **Bastion**.
3. Authenticate with username `azureuser` and your SSH private key.

Or via the Azure CLI:

```bash
az network bastion ssh \
  --name bastion-jump-box \
  --resource-group Vpr-rg \
  --target-resource-id your-vm-resource-id \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_ed25519
```

---

## Clean Up

```bash
terraform destroy
```

---

## License

This project is open-source and available under the [MIT License](LICENSE).
