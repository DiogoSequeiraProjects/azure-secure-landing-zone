terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "landingzone" {
  name     = "rg-secure-landing-zone"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-lz"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name
  address_space       = ["10.0.0.0/16"]
}
