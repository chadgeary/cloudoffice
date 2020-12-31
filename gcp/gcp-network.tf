resource "google_compute_network" "nc-network" {
  name                              = "${var.nc_prefix}-network"
  project                           = google_project.nc-project.project_id
  auto_create_subnetworks           = false
  depends_on                        = [google_project_service.nc-project-compute-service]
}

resource "google_compute_subnetwork" "nc-subnetwork" {
  name                              = "${var.nc_prefix}-subnetwork"
  project                           = google_project.nc-project.project_id
  network                           = google_compute_network.nc-network.id
  ip_cidr_range                     = var.gcp_cidr
  region                            = var.gcp_region
}

resource "google_compute_firewall" "nc-firewall-mgmt" {
  name                              = "${var.nc_prefix}-firewall-mgmt"
  project                           = google_project.nc-project.project_id
  network                           = google_compute_network.nc-network.self_link
  source_ranges                     = [var.mgmt_cidr]
  allow {
    protocol                          = "tcp"
    ports                             = ["22",var.web_port]
  }
}
