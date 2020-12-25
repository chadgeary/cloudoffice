data "google_iam_policy" "nc-service-account-iam-policy-data" {
  binding {
    role                              = "roles/iam.serviceAccountUser"
    members                           = ["user:${var.gcp_user}"]
  }
}

resource "google_service_account" "nc-service-account" {
  project                           = google_project.nc-project.project_id
  account_id                        = "${var.nc_prefix}-serviceaccount"
  display_name                      = "${var.nc_prefix}-serviceaccount"
}

resource "google_service_account_iam_policy" "nc-service-account-iam-policy" {
  service_account_id                = google_service_account.nc-service-account.name
  policy_data                       = data.google_iam_policy.nc-service-account-iam-policy-data.policy_data
}

resource "google_service_account_key" "nc-service-account-key" {
  service_account_id                = google_service_account.nc-service-account.name
}
