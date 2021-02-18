resource "azurerm_user_assigned_identity" "nc-instance-id" {
  name                    = "${var.nc_prefix}-instance-id-${random_string.nc-random.result}"
  location                = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name     = azurerm_resource_group.nc-resourcegroup.name
}

resource "random_uuid" "nc-instance-role-uuid" {
}

resource "azurerm_role_definition" "nc-instance-role" {
  name                    = "${var.nc_prefix}-instance-role-${random_string.nc-random.result}"
  role_definition_id      = random_uuid.nc-instance-role-uuid.result
  scope                   = data.azurerm_subscription.nc-subscription.id
  assignable_scopes       = [data.azurerm_subscription.nc-subscription.id]
  permissions {
    actions                 = [
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/listKeys/action",
      "Microsoft.Storage/storageAccounts/read"
    ]
    data_actions             = [
      "Microsoft.KeyVault/vaults/secrets/getSecret/action"
    ]
  }
}

resource "azurerm_role_assignment" "nc-instance-role-assignment" {
  scope                   = data.azurerm_subscription.nc-subscription.id
  role_definition_id      = azurerm_role_definition.nc-instance-role.role_definition_resource_id
  principal_id            = azurerm_user_assigned_identity.nc-instance-id.principal_id
}
