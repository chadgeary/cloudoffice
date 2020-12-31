output "nc-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH ##
  ssh ubuntu@${azurerm_public_ip.nc-public-ip.ip_address}

  ## WebUI ##
  https://${azurerm_public_ip.nc-public-ip.ip_address}:${var.web_port}/

  ## Update Containers / Ansible Rerun Instructions ##
  ssh ubuntu@${azurerm_public_ip.nc-public-ip.ip_address}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f nextcloud_application nextcloud_database nextcloud_webproxy nextcloud_storagegw

  # Update project
  cd /opt/git/nextcloud
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  ansible-playbook nextcloud_azure.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_storagegw=${var.docker_storagegw} instance_public_ip=${azurerm_public_ip.nc-public-ip.ip_address} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} az_storage_account_name=${azurerm_storage_account.nc-storage-account.name}'
  OUTPUT
}
