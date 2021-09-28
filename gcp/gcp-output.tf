output "cloudblock-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############

## SSH ##
ssh ubuntu@${google_compute_address.nc-public-ip.address}

## WebUI ##
${var.enable_duckdns == 1 && var.web_port == "443" ? "https://${var.duckdns_domain}/nc/" : ""}${var.enable_duckdns == 1 && var.web_port != "443" ? "https://${var.duckdns_domain}:${var.web_port}/nc/" : ""}${var.enable_duckdns == 0 && var.web_port == "443" ? "https://${google_compute_address.nc-public-ip.address}/" : ""}${var.enable_duckdns == 0 && var.web_port != "443" ? "https://${google_compute_address.nc-public-ip.address}:${var.web_port}/" : ""}

## ################### ##
## Update Instructions ##
## ################### ##
ssh ubuntu@${google_compute_address.nc-public-ip.address}

# If updating containers
# remove the old containers - this brings down the service until ansible is re-applied.
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_storagegateway cloudoffice_onlyoffice

# Re-apply Ansible playbook with custom variables
sudo systemctl start cloudoffice-ansible-state.service
OUTPUT
}
