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

resource "azurerm_subnet" "management" {
  name                 = "subnet-management"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "subnet-private"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "workload" {
  name                 = "subnet-workload"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private-subnet"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name
}

resource "azurerm_network_security_rule" "deny_internet_inbound" {
  name                        = "Deny-Internet-Inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.landingzone.name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

