resource "azurerm_network_interface" "vm1-nic" {
  name                = var.vm1-nic
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.vm1-nic
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm1-name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2as_v2"
  admin_username      = var.admin-username
  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin-username
    public_key = file(var.path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = var.env[0]
  }
}



resource "azurerm_network_interface" "vm2-nic" {
  name                = var.vm2-nic
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.vm2-nic
    subnet_id                     = azurerm_subnet.sn2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                = var.vm2-name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2as_v2"
  admin_username      = var.admin-username
  network_interface_ids = [
    azurerm_network_interface.vm2-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin-username
    public_key = file(var.path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = var.env[1]
  }
}


resource "azurerm_public_ip" "bastion-box-pip" {
  name                = var.bastion_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard" 
}

resource "azurerm_bastion_host" "bastion_box" {
  name                = var.bastion-box-name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion-configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-box-pip.id
  }
}
