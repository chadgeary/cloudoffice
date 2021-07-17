data "google_compute_image" "nc-gcp-image" {
  project = var.gcp_image_project
  name    = var.gcp_image_name
}

resource "google_compute_address" "nc-public-ip" {
  name         = "${var.nc_prefix}-public-ip"
  project      = google_project.nc-project.project_id
  region       = var.gcp_region
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  depends_on   = [google_project_service.nc-project-services]
}

locals {
  ssh_key_formatted = length(split(" ", var.ssh_key)) == 3 ? var.ssh_key : "${var.ssh_key} ubuntu"
}


resource "google_compute_instance" "nc-instance" {
  name         = "${var.nc_prefix}-instance"
  zone         = "${var.gcp_region}-${var.gcp_zone}"
  machine_type = var.gcp_machine_type
  project      = google_project.nc-project.project_id
  metadata = {
    ssh-keys       = "${var.ssh_user}:${local.ssh_key_formatted}"
    startup-script = "tee /etc/systemd/system/cloudoffice-ansible-state.service << EOM\n[Unit]\nDescription=cloudoffice-ansible-state\nAfter=network.target\n\n[Service]\nExecStart=/opt/cloudoffice-ansible-state.sh\nType=simple\nRestart=on-failure   \nRestartSec=30\n\n[Install]\nWantedBy=multi-user.target\nEOM\n\n# Create systemd timer unit file\ntee /etc/systemd/system/cloudoffice-ansible-state.timer << EOM\n[Unit]\nDescription=Starts cloudoffice ansible state playbook 1min after boot\n\n[Timer]\nOnBootSec=1mi\nnUnit=cloudoffice-ansible-state.service\n\n[Install]\nWantedBy=multi-user.target\nEOM\n\n# Create cloudoffice-ansible-state script\ntee /opt/cloudoffice-ansible-state.sh << EOM\n#!/bin/bash\n# package update\napt-get update\n# install prereqs\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\npip3 install --upgrade pip\n# use pip to install ansible\npip3 install --upgrade ansible\n# make the project directory and clone/pull the project\nmkdir -p /opt/git/cloudoffice\ngit clone ${var.project_url} /opt/git/cloudoffice/\ncd /opt/git/cloudoffice/\ngit pull\ncd playbooks/\n# run the playbook\nansible-playbook cloudoffice_gcp.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_storagegw=${var.docker_storagegw} docker_onlyoffice=${var.docker_onlyoffice} docker_duckdnsupdater=${var.docker_duckdnsupdater} gcp_project_prefix=${var.nc_prefix} gcp_project_suffix=${random_string.nc-random.result} instance_public_ip=${google_compute_address.nc-public-ip.address} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory} enable_duckdns=${var.enable_duckdns} duckdns_domain=${var.duckdns_domain} duckdns_token=${var.duckdns_token} letsencrypt_email=${var.letsencrypt_email}' >> /var/log/cloudoffice.log\nEOM\n\n# Start / Enable cloudoffice-ansible-state\nchmod +x /opt/cloudoffice-ansible-state.sh\nsystemctl daemon-reload\nsystemctl start cloudoffice-ansible-state.timer\nsystemctl start cloudoffice-ansible-state.service\nsystemctl enable cloudoffice-ansible-state.timer\nsystemctl enable cloudoffice-ansible-state.service"
  }
  boot_disk {
    kms_key_self_link = google_kms_crypto_key.nc-key-compute.self_link
    initialize_params {
      image = data.google_compute_image.nc-gcp-image.self_link
      type  = "pd-standard"
      size  = var.disk_gb
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.nc-subnetwork.self_link
    network_ip = var.gcp_instanceip
    access_config {
      nat_ip       = google_compute_address.nc-public-ip.address
      network_tier = "STANDARD"
    }
  }
  service_account {
    email  = google_service_account.nc-service-account.email
    scopes = ["cloud-platform", "storage-rw"]
  }
  allow_stopping_for_update = true
  depends_on                = [google_kms_crypto_key_iam_binding.nc-key-compute-binding, google_service_account_iam_policy.nc-service-account-iam-policy, google_storage_bucket.nc-bucket]
}
