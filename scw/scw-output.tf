output "cloudblock-output" {
value = <<OUTPUT

#############
## OUTPUTS ##
#############
# SSH #
ssh ubuntu@${scaleway_instance_ip.nc-ip.address}

# WebUI #
https://${scaleway_instance_ip.nc-ip.address}:${var.web_port}/

## ##################### ##
## Ansible Service Setup ##
## ##################### ##
scp ${var.nc_prefix}-setup-${random_string.nc-random.result}.sh ubuntu@${scaleway_instance_ip.nc-ip.address}:~/${var.nc_prefix}-setup-${random_string.nc-random.result}.sh
ssh ubuntu@${scaleway_instance_ip.nc-ip.address} "chmod +x ${var.nc_prefix}-setup-${random_string.nc-random.result}.sh && ~/${var.nc_prefix}-setup-${random_string.nc-random.result}.sh"

## ################################################ ##
## Update Containers and Ansible Rerun Instructions ##
## ################################################ ##
ssh ubuntu@${scaleway_instance_ip.nc-ip.address}

# If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_onlyoffice

# Re-apply Ansible playbook via systemd service
sudo systemctl start cloudoffice-ansible-state.service

OUTPUT
}
