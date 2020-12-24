resource "google_kms_key_ring" "nc-keyring" {
  name                              = "${var.nc_prefix}-keyring"
  location                          = var.gcp_region
  project                           = google_project.nc-project.project_id
  depends_on                        = [google_project_service.nc-project-services]
}

resource "google_kms_crypto_key" "nc-key-compute" {
  name                              = "${var.nc_prefix}-key-compute"
  key_ring                          = google_kms_key_ring.nc-keyring.id
  rotation_period                   = "100000s"
}

resource "google_kms_crypto_key_iam_binding" "nc-key-compute-binding" {
  crypto_key_id                     = google_kms_crypto_key.nc-key-compute.id
  role                              = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members                           = [
    "serviceAccount:service-${google_project.nc-project.number}@compute-system.iam.gserviceaccount.com"
  ]
}

resource "google_kms_crypto_key" "nc-key-storage" {
  name                              = "${var.nc_prefix}-key-storage"
  key_ring                          = google_kms_key_ring.nc-keyring.id
  rotation_period                   = "100000s"
}

resource "google_kms_crypto_key_iam_binding" "nc-key-storage-binding" {
  crypto_key_id                     = google_kms_crypto_key.nc-key-storage.id
  role                              = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members                           = [
    "serviceAccount:service-${google_project.nc-project.number}@gs-project-accounts.iam.gserviceaccount.com",
    "serviceAccount:${google_service_account.nc-service-account.email}"
  ]
  depends_on                        = [data.google_storage_project_service_account.nc-storage-account]
}
