terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

variable "vm_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" {}

variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "image_version" {}
variable "subnet_id" {}

variable "admin_username" {}

#
# In a real deployment Morpheus would inject this value
# from Cypher at runtime.
#
variable "admin_password" {}

resource "azurerm_network_interface" "win11_nic" {

  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"

    subnet_id = var.subnet_id
  }
}

resource "azurerm_windows_virtual_machine" "win11" {

  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  size = var.vm_size

  admin_username = var.admin_username

  #
  # Populated from Cypher
  #
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.win11_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {

    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
