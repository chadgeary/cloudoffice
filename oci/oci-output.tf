output "nc-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############

## SSH ##
ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

## WebUI ##
${var.enable_duckdns == 1 && var.web_port == "443" ? "https://${var.duckdns_domain}/nc" : ""}${var.enable_duckdns == 1 && var.web_port != "443" ? "https://${var.duckdns_domain}:${var.web_port}/nc" : ""}${var.enable_duckdns == 0 && var.web_port == "443" ? "https://${oci_core_instance.nc-instance.public_ip}" : ""}${var.enable_duckdns == 0 && var.web_port != "443" ? "https://${oci_core_instance.nc-instance.public_ip}:${var.web_port}/" : ""}

## ################### ##
## Update Instructions ##
## ################### ##
ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

# If updating containers
# remove the old containers - this brings down the service until ansible is re-applied.
sudo docker rm -f cloudoffice_database cloudoffice_nextcloud cloudoffice_webproxy cloudoffice_onlyoffice

# Re-apply Ansible playbook with custom variables
sudo systemctl start cloudoffice-ansible-state.service

## ########## ##
## Destroying ##
## ########## ##
# If destroying a project, delete all bucket objects before running terraform destroy, e.g:
oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.nc-bucket.name} -ns ${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace}
oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.nc-bucket.name}-data -ns ${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace}
OUTPUT
}
