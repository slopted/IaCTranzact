output "resource_group_name" {
  value = azurerm_resource_group.IaCTranzact-RG.name
}

output "network_security_group1_name" {
  value = azurerm_network_security_group.IaCTranzact-NSG1.name
}

output "network_security_group2_name" {
  value = azurerm_network_security_group.IaCTranzact-NSG2.name
}

output "virtual_network_Name" {
  value = azurerm_virtual_network.IaCTranzact-VNET
}