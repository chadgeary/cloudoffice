data "google_compute_image" "nc-gcp-image" {
  project                           = var.gcp_image_project
  name                              = var.gcp_image_name
}

resource "google_compute_address" "nc-public-ip" {
  name                              = "${var.nc_prefix}-public-ip"
  project                           = google_project.nc-project.project_id
  region                            = var.gcp_region
  address_type                      = "EXTERNAL"
  network_tier                      = "STANDARD"
  depends_on                        = [google_project_service.nc-project-services]
}

resource "google_compute_instance" "nc-instance" {
  name                              = "${var.nc_prefix}-instance"
  zone                              = "${var.gcp_region}-${var.gcp_zone}"
  machine_type                      = var.gcp_machine_type
  project                           = google_project.nc-project.project_id
  metadata                          = {
    ssh-keys                          = "${var.ssh_user}:${var.ssh_key}"
    startup-script                    = "#!/bin/bash\napt-get update\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\npip3 install --upgrade ansible\nmkdir -p /opt/git/nextcloud\ngit clone ${var.project_url} /opt/git/nextcloud/\ncd /opt/git/nextcloud/\ngit pull\ncd playbooks/\nansible-playbook nextcloud_gcp.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_storagegw=${var.docker_storagegw} docker_onlyoffice=${var.docker_onlyoffice} gcp_project_prefix=${var.nc_prefix} gcp_project_suffix=${random_string.nc-random.result} instance_public_ip=${google_compute_address.nc-public-ip.address} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory}' >> /var/log/nextcloud.log"
  }
  boot_disk {
    kms_key_self_link                 = google_kms_crypto_key.nc-key-compute.self_link
    initialize_params {
      image                             = data.google_compute_image.nc-gcp-image.self_link
      type                              = "pd-standard"
      size                              = var.disk_gb
    }
  }
  network_interface {
    subnetwork                        = google_compute_subnetwork.nc-subnetwork.self_link
    network_ip                        = var.gcp_instanceip
    access_config {
      nat_ip                            = google_compute_address.nc-public-ip.address
      network_tier                      = "STANDARD"
    }
  }
  service_account {
    email                             = google_service_account.nc-service-account.email
    scopes                            = ["cloud-platform","storage-rw"]
  }
  allow_stopping_for_update         = true
  depends_on                        = [google_kms_crypto_key_iam_binding.nc-key-compute-binding,google_service_account_iam_policy.nc-service-account-iam-policy,google_storage_bucket.nc-bucket]
}
