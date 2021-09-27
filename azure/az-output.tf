output "nc-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############

## SSH ##
ssh ubuntu@${azurerm_public_ip.nc-public-ip.ip_address}

## WebUI ##
${var.enable_duckdns == 1 && var.web_port == "443" ? "https://${var.duckdns_domain}/nc" : ""}${var.enable_duckdns == 1 && var.web_port != "443" ? "https://${var.duckdns_domain}:${var.web_port}/nc" : ""}${var.enable_duckdns == 0 && var.web_port == "443" ? "https://${azurerm_public_ip.nc-public-ip.ip_address}" : ""}${var.enable_duckdns == 0 && var.web_port != "443" ? "https://${azurerm_public_ip.nc-public-ip.ip_address}:${var.web_port}/" : ""}

## ################### ##
## Update Instructions ##
## ################### ##
ssh ubuntu@${azurerm_public_ip.nc-public-ip.ip_address}

# If updating containers
# remove the old containers - this brings down the service until ansible is re-applied.
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_storagegateway cloudoffice_onlyoffice

# Re-apply Ansible playbook with custom variables
sudo systemctl start cloudoffice-ansible-state.service
OUTPUT
}
