resource "azurerm_resource_group" "IaCTranzact-RG" {
    location = var.DefaultLocation
    name     = local.rg_name
    
    tags = merge(local.tags)
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

  tags = merge(local.tags)

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

  tags = merge(local.tags)

}

resource "azurerm_virtual_network" "IaCTranzact-VNET" {
  name                = local.vnet_name
  location            = azurerm_resource_group.IaCTranzact-RG.location
  resource_group_name = azurerm_resource_group.IaCTranzact-RG.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  tags                = merge(local.tags)
}
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.IaCTranzact-RG.name
  virtual_network_name = azurerm_virtual_network.IaCTranzact-VNET.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault","Microsoft.Storage"]
}
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.IaCTranzact-RG.name
  virtual_network_name = azurerm_virtual_network.IaCTranzact-VNET.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.KeyVault","Microsoft.Storage"]
}
resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.IaCTranzact-RG.name
  virtual_network_name = azurerm_virtual_network.IaCTranzact-VNET.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.KeyVault","Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "IaCTranzact_Association1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.IaCTranzact-NSG1.id
}
resource "azurerm_subnet_network_security_group_association" "IaCTranzact_Association2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.IaCTranzact-NSG2.id
}

resource "azurerm_key_vault" "IaCTranzact-KEYV" {
  name                       = local.keyv_name
  location                   = azurerm_resource_group.IaCTranzact-RG.location
  resource_group_name        = azurerm_resource_group.IaCTranzact-RG.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
    secret_permissions = ["Get","List","Set","Delete","Recover","Backup","Restore","Purge"]
    storage_permissions = ["Get"]
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.user_object
    key_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
    secret_permissions = ["Get","List","Set","Delete","Recover","Backup","Restore","Purge"]
    storage_permissions = ["Get"]
  }
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["38.25.17.22"]
    virtual_network_subnet_ids = ["${azurerm_subnet.subnet3.id}"]
  }
  tags = merge(local.tags)
}

resource "azurerm_key_vault_secret" "IaCTranzact-KEYV-Secret" {
  name         = local.keyv_secret_name
  value        = "hff8Q~ZjHjlczhtnOLOxQCy2ihmjLXc9s5w_Hbei"
  key_vault_id = azurerm_key_vault.IaCTranzact-KEYV.id
  tags = merge(local.tags)
}

resource "azurerm_storage_account" "IaCTranzact-SA" {
  name                = local.sa_name
  resource_group_name = azurerm_resource_group.IaCTranzact-RG.name

  location                 = var.DefaultLocation
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = ["38.25.17.22"]
    virtual_network_subnet_ids = ["${azurerm_subnet.subnet2.id}"]
  }
  tags = merge(local.tags)
}

resource "azurerm_storage_container" "IaCTranzact-SA" {
  name                  = local.sac_name
  storage_account_name  = azurerm_storage_account.IaCTranzact-SA.name
  container_access_type = "private"
}