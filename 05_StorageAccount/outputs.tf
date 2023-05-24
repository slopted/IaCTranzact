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
  value = azurerm_virtual_network.IaCTranzact-VNET.name
}

output "subnet1_Name" {
  value = azurerm_subnet.subnet1.name
}

output "subnet2_Name" {
  value = azurerm_subnet.subnet2.name
}

output "subnet3_Name" {
  value = azurerm_subnet.subnet3.name
}

output "Storage_accounts_Name" {
  value = azurerm_storage_account.IaCTranzact-SA.name
}

output "Storage_container_Name" {
  value = azurerm_storage_container.IaCTranzact-SA.name
}