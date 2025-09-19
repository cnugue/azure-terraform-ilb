resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = 2
  name                = "MyVM-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_assoc" {
  count                   = 2
  network_interface_id    = element(azurerm_network_interface.nic[*].id, count.index)
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.lb_backend_pool
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.nic : nic.ip_configuration[0].private_ip_address]
}

variable "rg_name" {}
variable "location" {}
variable "subnet_id" {}
variable "lb_backend_pool" {}
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
