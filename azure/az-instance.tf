resource "azurerm_network_interface" "nc-net-interface" {
  name                = "${var.nc_prefix}-nic"
  location            = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name = azurerm_resource_group.nc-resourcegroup.name
  ip_configuration {
    name                          = "${var.nc_prefix}-ipconf"
    subnet_id                     = azurerm_subnet.nc-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nc-public-ip.id
    primary                       = true
  }
}

data "template_file" "nc-custom-data" {
  template = file("az-custom_data.tpl")
  vars = {
    project_url             = var.project_url
    nc_prefix               = var.nc_prefix
    nc_suffix               = random_string.nc-random.result
    docker_network          = var.docker_network
    docker_gw               = var.docker_gw
    docker_nextcloud        = var.docker_nextcloud
    docker_db               = var.docker_db
    docker_webproxy         = var.docker_webproxy
    docker_storagegw        = var.docker_storagegw
    docker_onlyoffice       = var.docker_onlyoffice
    docker_duckdnsupdater   = var.docker_duckdnsupdater
    instance_public_ip      = azurerm_public_ip.nc-public-ip.ip_address
    az_storage_account_name = azurerm_storage_account.nc-storage-account.name
    web_port                = var.web_port
    oo_port                 = var.oo_port
    project_directory       = var.project_directory
    enable_duckdns          = var.enable_duckdns
    duckdns_domain          = data.azurerm_key_vault_secret.duckdns_domain.value
    duckdns_token           = data.azurerm_key_vault_secret.duckdns_token.value
    letsencrypt_email       = var.letsencrypt_email
  }
}

resource "azurerm_linux_virtual_machine" "nc-instance" {
  name                  = "${var.nc_prefix}-instance"
  location              = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name   = azurerm_resource_group.nc-resourcegroup.name
  size                  = var.az_vm_size
  admin_username        = var.ssh_user
  network_interface_ids = [azurerm_network_interface.nc-net-interface.id]
  admin_ssh_key {
    username   = var.ssh_user
    public_key = data.azurerm_key_vault_secret.ssh_key.value
  }
  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = azurerm_disk_encryption_set.nc-disk-encrypt.id
    disk_size_gb           = var.az_disk_gb
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = var.az_image_version
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.nc-instance-id.id]
  }
  custom_data = base64encode(data.template_file.nc-custom-data.rendered)
  tags = {
  }
  depends_on = [azurerm_key_vault_access_policy.nc-vault-disk-access-disk, azurerm_role_assignment.nc-instance-role-assignment, azurerm_key_vault.nc-vault-disk]
}
