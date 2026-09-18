output "bastion_ip" {
    value = azurerm_public_ip.bastion-box-pip.ip_address
}