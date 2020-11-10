provider "azurerm" {
  version = "2.16.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "demo3-${var.env}"
  location = "westeurope"
}

variable "env" {
}

resource "azurerm_virtual_network" "vnet" {
  name                = "demo3-vnet-${var.env}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subn" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"] 
}

module "vm1" {
  source = "../modules/vm/vm-v1.0"
  resource-group-name = azurerm_resource_group.rg.name
  vm-name = "Demo3-vm-${var.env}"
  location = "westeurope"
  admin-username = "Joran"
  password = "p@55W0rd!#"
  subnet-id = azurerm_subnet.subn.id
}


# module "vm2" {
#   source = "../modules/vm/vm-v1.0"
#   resource-group-name = azurerm_resource_group.rg.name
#   vm-name = "Demo3-vm2-${var.env}"
#   location = "westeurope"
#   admin-username = "Bjorn"
#   password = "p@55W0rd!#"
#   subnet-id = azurerm_subnet.subn.id
# }
