resource "azurerm_key_vault" "nc-vault-disk" {
  name                        = "${var.nc_prefix}-disk-${random_string.nc-random.result}"
  location                    = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name         = azurerm_resource_group.nc-resourcegroup.name
  tenant_id                   = data.azurerm_client_config.nc-client-conf.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  access_policy {
    tenant_id       = data.azurerm_client_config.nc-client-conf.tenant_id
    object_id       = data.azurerm_client_config.nc-client-conf.object_id
    key_permissions = ["Get", "Create", "Delete", "List", "Restore", "Recover", "Unwrapkey", "Wrapkey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  }
}

resource "azurerm_key_vault" "nc-vault-storage" {
  name                     = "${var.nc_prefix}-store-${random_string.nc-random.result}"
  location                 = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name      = azurerm_resource_group.nc-resourcegroup.name
  tenant_id                = data.azurerm_client_config.nc-client-conf.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  access_policy {
    tenant_id       = data.azurerm_client_config.nc-client-conf.tenant_id
    object_id       = data.azurerm_client_config.nc-client-conf.object_id
    key_permissions = ["Get", "Create", "Delete", "List", "Restore", "Recover", "Unwrapkey", "Wrapkey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  }
  access_policy {
    tenant_id       = data.azurerm_client_config.nc-client-conf.tenant_id
    object_id       = azurerm_storage_account.nc-storage-account.identity.0.principal_id
    key_permissions = ["Get", "Create", "List", "Restore", "Recover", "Unwrapkey", "Wrapkey", "Encrypt", "Decrypt", "Sign", "Verify"]
  }
}

resource "azurerm_key_vault" "nc-vault-secret" {
  name                     = "${var.nc_prefix}-secret-${random_string.nc-random.result}"
  location                 = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name      = azurerm_resource_group.nc-resourcegroup.name
  tenant_id                = data.azurerm_client_config.nc-client-conf.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  access_policy {
    tenant_id          = data.azurerm_client_config.nc-client-conf.tenant_id
    object_id          = data.azurerm_client_config.nc-client-conf.object_id
    secret_permissions = ["set", "get", "delete", "list", "purge", "recover", "restore"]
  }
  access_policy {
    tenant_id          = data.azurerm_client_config.nc-client-conf.tenant_id
    object_id          = azurerm_user_assigned_identity.nc-instance-id.principal_id
    secret_permissions = ["get", "list"]
  }
}

resource "azurerm_disk_encryption_set" "nc-disk-encrypt" {
  name                = "${var.nc_prefix}-disk-encrypt"
  location            = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name = azurerm_resource_group.nc-resourcegroup.name
  key_vault_key_id    = azurerm_key_vault_key.nc-disk-key.id
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "nc-vault-disk-access-disk" {
  key_vault_id    = azurerm_key_vault.nc-vault-disk.id
  tenant_id       = azurerm_disk_encryption_set.nc-disk-encrypt.identity.0.tenant_id
  object_id       = azurerm_disk_encryption_set.nc-disk-encrypt.identity.0.principal_id
  key_permissions = ["Get", "Decrypt", "Encrypt", "Sign", "UnwrapKey", "Verify", "WrapKey", "UnwrapKey"]
}

resource "time_sleep" "wait_for_vaults" {
  create_duration = "30s"
  depends_on      = [azurerm_key_vault.nc-vault-disk]
}

resource "azurerm_key_vault_key" "nc-disk-key" {
  name         = "${var.nc_prefix}-disk-key"
  key_vault_id = azurerm_key_vault.nc-vault-disk.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on   = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_key" "nc-storage-key" {
  name         = "${var.nc_prefix}-storage-key"
  key_vault_id = azurerm_key_vault.nc-vault-storage.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on   = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_secret" "nc-admin-secret" {
  name         = "${var.nc_prefix}-admin-secret"
  value        = random_password.admin_password.result
  key_vault_id = azurerm_key_vault.nc-vault-secret.id
  depends_on   = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_secret" "nc-db-secret" {
  name         = "${var.nc_prefix}-db-secret"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.nc-vault-secret.id
  depends_on   = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_secret" "nc-oo-secret" {
  name         = "${var.nc_prefix}-oo-secret"
  value        = random_password.oo_password.result
  key_vault_id = azurerm_key_vault.nc-vault-secret.id
  depends_on   = [time_sleep.wait_for_vaults]
}

resource "azurerm_key_vault_secret" "nc-storage-secret" {
  name         = "${var.nc_prefix}-storage-secret"
  value        = azurerm_storage_account.nc-storage-account.primary_access_key
  key_vault_id = azurerm_key_vault.nc-vault-secret.id
  depends_on   = [time_sleep.wait_for_vaults]
}
