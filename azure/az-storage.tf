resource "azurerm_storage_account" "nc-storage-account" {
  name                            = "${var.nc_prefix}store${random_string.nc-random.result}"
  location                        = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name             = azurerm_resource_group.nc-resourcegroup.name
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = "false"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_account_customer_managed_key" "nc-storage-cmk" {
  storage_account_id = azurerm_storage_account.nc-storage-account.id
  key_vault_id       = azurerm_key_vault.nc-vault-storage.id
  key_name           = azurerm_key_vault_key.nc-storage-key.name
}

resource "azurerm_storage_container" "nc-storage-container" {
  name                  = "${var.nc_prefix}-storage-container"
  storage_account_name  = azurerm_storage_account.nc-storage-account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "nc-storage-container-data" {
  name                  = "${var.nc_prefix}-storage-container-data"
  storage_account_name  = azurerm_storage_account.nc-storage-account.name
  container_access_type = "private"
}
