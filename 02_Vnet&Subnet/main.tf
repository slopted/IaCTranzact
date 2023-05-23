resource "azurerm_resource_group" "IaCTranzact-RG" {
    location = var.DefaultLocation
    name     = local.rg_name
    
    tags = {
    owner = "AndresSanchez"
    }
}

resource "azurerm_network_security_group" "IaCTranzact-NSG1" {
  name                = local.nsg1_name
  location            = azurerm_resource_group.IaCTranzact-RG.location
  resource_group_name = azurerm_resource_group.IaCTranzact-RG.name
  
  security_rule {
    name                       = "SecRul1-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    owner = "AndresSanchez"
  }

}

resource "azurerm_network_security_group" "IaCTranzact-NSG2" {
  name                = local.nsg2_name
  location            = azurerm_resource_group.IaCTranzact-RG.location
  resource_group_name = azurerm_resource_group.IaCTranzact-RG.name
  
  security_rule {
    name                       = "SecRul1-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SecRul2-MySQL"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3306"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    owner = "AndresSanchez"
  }

}

resource "azurerm_virtual_network" "IaCTranzact-VNET" {
  name                = local.vnet_name
  location            = azurerm_resource_group.IaCTranzact-RG.location
  resource_group_name = azurerm_resource_group.IaCTranzact-RG.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.IaCTranzact-NSG1.id
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.IaCTranzact-NSG2.id
  }

  tags = {
    owner = "AndresSanchez"
  }
  
}