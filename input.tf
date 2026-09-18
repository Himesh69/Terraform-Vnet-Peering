variable "vpr" {
    type = string
    description = "Name of the Resource group"
}

variable "location"{
    type = string
    description = "Location of the Resource group"
}

variable "vnet1" {
    type = string
    description = "Name of the VNet1"
}

variable "vnet2" {
    type = string
    description = "Name of the VNet2"
}

variable "subnet1" {
    type = string
    description = "Name of the subnet1"
}

variable "subnet2" {
    type = string
    description = "Name of the subnet2"
}

variable "vm1-nic" {
    type = string
    description = "Name of the VM1-nic"
}

variable "vm2-nic" {
    type = string
    description = "Name of the VM2-nic"
}

variable "vm1-name" {
    type = string
    description = "Name of the VM1"
}

variable "vm2-name" {
    type = string
    description = "Name of the VM2"
}

variable "compute-size"{
    type = string
    description = "Size of the VM"
}

variable "env"{
    type = list
    description = "environment"
    default = ["dev","satge"]
}

variable "admin-username"{
    type = string
    description = "admin username"
}

variable "bastion-box-name"{
    type = string
    description = "Name of the bastion box"
}

variable "bastion_ip_name" {
    type = string
    description = "Public ip name for bastion host"
}

variable "path" {
    type = string
    description = "Path to the public key"
}