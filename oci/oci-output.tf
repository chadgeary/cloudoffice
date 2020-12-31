output "nc-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH ##
  ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

  ## WebUI ##
  https://${oci_core_instance.nc-instance.public_ip}:${var.web_port}/

  ## Update / Ansible Rerun Instructions ##
  ssh ubuntu@${oci_core_instance.nc-instance.public_ip}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f nextcloud_database nextcloud_application nextcloud_webproxy

  # Update project
  cd /opt/git/nextcloud/
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  sudo su
  ansible-playbook nextcloud_oci.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} admin_password_cipher=${oci_kms_encrypted_data.nc-kms-nc-admin-secret.ciphertext} db_password_cipher=${oci_kms_encrypted_data.nc-kms-nc-db-secret.ciphertext} oci_kms_endpoint=${oci_kms_vault.nc-kms-storage-vault.crypto_endpoint} oci_kms_keyid=${oci_kms_key.nc-kms-storage-key.id} oci_storage_namespace=${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace} oci_storage_bucketname=${var.nc_prefix}-bucket oci_region=${var.oci_region} oci_root_compartment=${var.oci_root_compartment} bucket_user_key_cipher=${oci_kms_encrypted_data.nc-kms-bucket-user-key-secret.ciphertext} bucket_user_id=${oci_identity_customer_secret_key.nc-bucker-user-key.id} project_directory=${var.project_directory} web_port=${var.web_port}'

  # If destroying a project, delete all bucket objects before running terraform destroy, e.g:
  oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.nc-bucket.name} -ns ${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace}
  oci os object bulk-delete-versions -bn ${oci_objectstorage_bucket.nc-bucket.name}-data -ns ${data.oci_objectstorage_namespace.nc-bucket-namespace.namespace}
  OUTPUT
}
