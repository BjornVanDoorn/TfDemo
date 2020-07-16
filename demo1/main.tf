provider "azurerm" {
  version = "2.16.0"
  features {}
}

resource "azurerm_resource_group" "demo-rg" {
  name     = "Tf-Demo-01"
  location = "West Europe"
}

resource "azurerm_storage_account" "demo-StorageAccount" {
  name                     = "demoaccounttfsession"
  resource_group_name      = azurerm_resource_group.demo-rg.name
  location                 = azurerm_resource_group.demo-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Demo"
  }
}