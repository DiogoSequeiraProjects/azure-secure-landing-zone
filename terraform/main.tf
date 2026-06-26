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

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "landingzone" {
  name     = "rg-secure-landing-zone"
  location = "West Europe"

  tags = var.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-lz"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name
  address_space       = ["10.0.0.0/16"]

  tags = var.common_tags
}

resource "azurerm_subnet" "management" {
  name                 = "subnet-management"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
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

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private-subnet"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name

  tags = var.common_tags
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

resource "azurerm_management_lock" "resource_group_lock" {
  name       = "delete-protection"
  scope      = azurerm_resource_group.landingzone.id
  lock_level = "CanNotDelete"
  notes      = "Protect Secure Landing Zone resources from accidental deletion."
}

data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations-west-europe"
  resource_group_id    = azurerm_resource_group.landingzone.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  display_name         = "Allowed Locations - West Europe"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = [
        "westeurope"
      ]
    }
  })
}

resource "azurerm_key_vault" "secure_kv" {
  name                = "kv-secure-lz"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.common_tags
}

resource "azurerm_private_endpoint" "key_vault_pe" {
  name                = "pe-key-vault-secure-lz"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "psc-key-vault-secure-lz"
    private_connection_resource_id = azurerm_key_vault.secure_kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.common_tags
}
