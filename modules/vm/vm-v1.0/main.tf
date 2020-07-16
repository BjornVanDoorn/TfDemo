


resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm-name}"
  location            = var.location
  resource_group_name = var.resource-group-name

  ip_configuration {
    name                          = "DemoConfig"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm-name
  location              = var.location
  resource_group_name   = var.resource-group-name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myos-${var.vm-name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm-name
    admin_username = var.admin-username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}