output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH ##
  ssh ubuntu@${digitalocean_floating_ip.nc-ip.ip_address}

  ## WebUI ##
  https://${digitalocean_floating_ip.nc-ip.ip_address}:${var.web_port}/

  ## Update Containers / Ansible Rerun Instructions ##
  ssh ubuntu@${digitalocean_floating_ip.nc-ip.ip_address}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f nextcloud_application nextcloud_database nextcloud_webproxy nextcloud_onlyoffice

  # Update project
  cd /opt/git/nextcloud/
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  sudo ansible-playbook nextcloud_do.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_onlyoffice=${var.docker_onlyoffice} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} do_storageaccessid=${var.do_storageaccessid} do_storagesecretkey=${var.do_storagesecretkey} do_region=${var.do_region} instance_public_ip=${digitalocean_floating_ip.nc-ip.ip_address} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory} admin_password=${var.admin_password} db_password=${var.db_password} oo_password=${var.oo_password}'
  
  ## Destroying ##
  
  # Before terraform destroy, delete all objects from buckets using the aws CLI - this action is irreversible.
  # Install awscli via pip3
  sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip
  pip3 install --user --upgrade awscli
  # Set credentials
  aws configure set aws_access_key_id ${var.do_storageaccessid}
  aws configure set aws_access_secret_key ${var.do_storagesecretkey}
  # Remove objects
  aws s3 rm --recursive s3://${var.nc_prefix}-bucket-${random_string.nc-random.result}/ --endpoint https://${var.do_region}.digitaloceanspaces.com
  aws s3 rm --recursive s3://${var.nc_prefix}-bucket-data-${random_string.nc-random.result}/ --endpoint https://${var.do_region}.digitaloceanspaces.com
  OUTPUT
}
