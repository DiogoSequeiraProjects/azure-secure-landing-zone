output "resource_group_name" {
  value = azurerm_resource_group.landingzone.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.private_nsg.name
}
