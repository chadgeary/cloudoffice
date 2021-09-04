output "cloudblock-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############
# SSH #
ssh ubuntu@${scaleway_instance_ip.nc-ip.address}

# WebUI #
https://${var.enable_duckdns == 1 ? "${var.duckdns_domain}/nc" : scaleway_instance_ip.nc-ip.address}${var.web_port == "443" ? "" : ":${var.web_port}"}/

## ############## ##
## One Time Setup ##
## ############## ##
scp ${var.nc_prefix}-setup-${random_string.nc-random.result}.sh ubuntu@${scaleway_instance_ip.nc-ip.address}:~/${var.nc_prefix}-setup-${random_string.nc-random.result}.sh
ssh ubuntu@${scaleway_instance_ip.nc-ip.address} "chmod +x ${var.nc_prefix}-setup-${random_string.nc-random.result}.sh && ~/${var.nc_prefix}-setup-${random_string.nc-random.result}.sh"

## ################### ##
## Update Instructions ##
## ################### ##
ssh ubuntu@${scaleway_instance_ip.nc-ip.address}

# If updating containers, update nextcloud, then
# remove the old containers - this brings down the service until ansible is re-applied.
sudo docker exec -it cloudoffice_nextcloud updater.phar
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_onlyoffice

# Re-apply Ansible playbook via systemd service
sudo systemctl start cloudoffice-ansible-state.service

## ########## ##
## Destroying ##
## ########## ##
# Before terraform destroy, delete all objects from buckets using the aws CLI - this action is irreversible.
# Install awscli via pip3
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip
pip3 install --user --upgrade awscli

# Set credentials
aws configure set aws_access_key_id ${var.scw_accesskey}
aws configure set aws_secret_access_key ${var.scw_secretkey}

# Remove objects
aws s3 rm --recursive s3://${var.nc_prefix}-backup-bucket-${random_string.nc-random.result}/ --endpoint https://s3.${var.scw_region}.scw.cloud --region ${var.scw_region}
aws s3 rm --recursive s3://${var.nc_prefix}-data-bucket-${random_string.nc-random.result}/ --endpoint https://s3.${var.scw_region}.scw.cloud --region ${var.scw_region}

OUTPUT
}
