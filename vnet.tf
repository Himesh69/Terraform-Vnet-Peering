resource "azurerm_resource_group" "rg"{
    name  = "${var.vpr}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
    name = var.vnet1
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet2" {
    name = var.vnet2
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["20.0.0.0/16"]
}

resource "azurerm_subnet" "sn1" {
  name                 = var.subnet1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "sn2" {
  name                 = var.subnet2
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["20.0.0.0/24"]
}

resource "azurerm_subnet" "bastion_subnet"{
    name = "AzureBastionSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes = ["10.0.1.0/26"]
}

resource "azurerm_virtual_network_peering" "vnet1-vnet2" {
  name                      = "vnet1-vnet2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_gateway_transit      = true
}

resource "azurerm_virtual_network_peering" "vnet2-vnet1" {
  name                      = "vnet2-vnet1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_gateway_transit      = true
}