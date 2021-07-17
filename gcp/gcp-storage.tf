data "google_storage_project_service_account" "nc-storage-account" {
  project = google_project.nc-project.project_id
}

# system bucket
resource "google_storage_bucket" "nc-bucket" {
  name     = "${var.nc_prefix}-bucket-${random_string.nc-random.result}"
  location = var.gcp_region
  project  = google_project.nc-project.project_id
  encryption {
    default_kms_key_name = google_kms_crypto_key.nc-key-storage.id
  }
  versioning {
    enabled = false
  }
  depends_on    = [google_kms_crypto_key_iam_binding.nc-key-storage-binding]
  force_destroy = true
}

resource "google_storage_bucket_acl" "nc-bucket-acl" {
  bucket = google_storage_bucket.nc-bucket.name
  role_entity = [
    "OWNER:project-owners-${google_project.nc-project.number}",
    "OWNER:project-editors-${google_project.nc-project.number}",
    "READER:project-viewers-${google_project.nc-project.number}",
    "OWNER:user-${var.gcp_user}",
    "OWNER:user-${google_service_account.nc-service-account.email}"
  ]
}

# data bucket
resource "google_storage_bucket" "nc-bucket-data" {
  name     = "${var.nc_prefix}-bucket-data-${random_string.nc-random.result}"
  location = var.gcp_region
  project  = google_project.nc-project.project_id
  versioning {
    enabled = false
  }
  depends_on    = [google_kms_crypto_key_iam_binding.nc-key-storage-binding]
  force_destroy = true
}

resource "google_storage_bucket_acl" "nc-bucket-data-acl" {
  bucket = google_storage_bucket.nc-bucket-data.name
  role_entity = [
    "OWNER:project-owners-${google_project.nc-project.number}",
    "OWNER:project-editors-${google_project.nc-project.number}",
    "READER:project-viewers-${google_project.nc-project.number}",
    "OWNER:user-${var.gcp_user}",
    "OWNER:user-${google_service_account.nc-service-account.email}"
  ]
}
