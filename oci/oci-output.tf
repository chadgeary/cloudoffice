output "nc-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH ##
  ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

  ## WebUI ##
  https://${oci_core_instance.nc-instance.public_ip}/

  ## Update / Ansible Rerun Instructions ##
  ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f nextcloud_db nextcloud_application nextcloud_webproxy

  # Update project
  cd /opt/git/nextcloud/
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  sudo su
  ansible-playbook nextcloud_oci.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} admin_password_cipher=${oci_kms_encrypted_data.nc-kms-nc-admin-secret.ciphertext} db_password_cipher=${oci_kms_encrypted_data.nc-kms-nc-db-secret.ciphertext} oci_kms_endpoint=${oci_kms_vault.nc-kms-storage-vault.crypto_endpoint} oci_kms_keyid=${oci_kms_key.nc-kms-storage-key.id} oci_storage_namespace=${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace} oci_storage_bucketname=${var.nc_prefix}-bucket'
  OUTPUT
}
