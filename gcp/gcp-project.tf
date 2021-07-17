resource "random_string" "nc-random" {
  length  = 5
  upper   = false
  special = false
}

resource "google_project" "nc-project" {
  name            = "${var.nc_prefix}-project"
  project_id      = "${var.nc_prefix}-project-${random_string.nc-random.result}"
  billing_account = var.gcp_billing_account
}

resource "google_project_service" "nc-project-compute-service" {
  project = google_project.nc-project.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "nc-project-services" {
  count      = length(var.gcp_project_services)
  project    = google_project.nc-project.project_id
  service    = var.gcp_project_services[count.index]
  depends_on = [google_project_service.nc-project-compute-service]
}
