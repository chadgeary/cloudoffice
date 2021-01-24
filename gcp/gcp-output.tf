output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH ##
  ssh ubuntu@${google_compute_address.nc-public-ip.address}

  ## WebUI ##
  https://${google_compute_address.nc-public-ip.address}:${var.web_port}/

  ## Update Containers / Ansible Rerun Instructions ##
  ssh ubuntu@${google_compute_address.nc-public-ip.address}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f nextcloud_application nextcloud_database nextcloud_webproxy nextcloud_storagegw

  # Re-apply Ansible playbook with custom variables
  sudo systemctl start cloudoffice-ansible-state.service
  OUTPUT
}
