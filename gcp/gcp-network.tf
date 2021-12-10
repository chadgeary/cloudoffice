resource "google_compute_network" "nc-network" {
  name                    = "${var.nc_prefix}-network"
  project                 = google_project.nc-project.project_id
  auto_create_subnetworks = false
  mtu                     = 1500
  depends_on              = [google_project_service.nc-project-compute-service]
}

resource "google_compute_subnetwork" "nc-subnetwork" {
  name          = "${var.nc_prefix}-subnetwork"
  project       = google_project.nc-project.project_id
  network       = google_compute_network.nc-network.id
  ip_cidr_range = var.gcp_cidr
  region        = var.gcp_region
}

locals {
  mgmt_ranges = [var.mgmt_cidr, google_compute_address.nc-public-ip.address]
}

resource "google_compute_firewall" "nc-firewall-mgmt" {
  name          = "${var.nc_prefix}-firewall-mgmt"
  project       = google_project.nc-project.project_id
  network       = google_compute_network.nc-network.self_link
  source_ranges = [var.mgmt_cidr, google_compute_address.nc-public-ip.address]
  source_tags   = ["${var.nc_prefix}-mgmt"]
  allow {
    protocol = "tcp"
    ports    = ["22", var.web_port, var.oo_port]
  }
}
