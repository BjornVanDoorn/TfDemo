provider "azurerm" {
  version = "2.16.0"
  features {}
}

provider "random" {
}

variable "env" {
}

resource "azurerm_resource_group" "rg" {
  name     = "Linux-VM-${var.env}"
  location = "West US 2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Linux-network-${var.env}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"] 
}

resource "azurerm_network_interface" "nic" {
  name                = "linux-vm-nic-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "DemoConfig"
    subnet_id                     = azurerm_subnet.subn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "linux-vm-${var.env}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "Demo-machine"
    admin_username = "testadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_resource_group" "rg-ai" {
  name     = "Ai-example"
  location = "West Europe"
}

resource "azurerm_application_insights" "ai" {
  name                = "ai-example-tf-domo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}