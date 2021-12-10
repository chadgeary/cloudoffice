# admin
resource "google_secret_manager_secret" "nc-secret-admin-password" {
  project   = google_project.nc-project.project_id
  secret_id = "${var.nc_prefix}-admin-password"
  replication {
    user_managed {
      replicas {
        customer_managed_encryption {
          kms_key_name = google_kms_crypto_key.nc-key-secret.id
        }
        location = var.gcp_region
      }
    }
  }
  depends_on = [google_project_service_identity.nc-project-services-identities, google_kms_crypto_key_iam_binding.nc-key-secret-binding]
}

resource "google_secret_manager_secret_version" "nc-secret-admin-password-version" {
  secret      = google_secret_manager_secret.nc-secret-admin-password.id
  secret_data = var.admin_password
}

# database
resource "google_secret_manager_secret" "nc-secret-db-password" {
  project   = google_project.nc-project.project_id
  secret_id = "${var.nc_prefix}-db-password"
  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
  depends_on = [google_project_service_identity.nc-project-services-identities, google_kms_crypto_key_iam_binding.nc-key-secret-binding]
}

resource "google_secret_manager_secret_version" "nc-secret-db-password-version" {
  secret      = google_secret_manager_secret.nc-secret-db-password.id
  secret_data = var.db_password
}

# onlyoffice
resource "google_secret_manager_secret" "nc-secret-oo-password" {
  project   = google_project.nc-project.project_id
  secret_id = "${var.nc_prefix}-oo-password"
  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
  depends_on = [google_project_service_identity.nc-project-services-identities, google_kms_crypto_key_iam_binding.nc-key-secret-binding]
}

resource "google_secret_manager_secret_version" "nc-secret-oo-password-version" {
  secret      = google_secret_manager_secret.nc-secret-oo-password.id
  secret_data = var.oo_password
}

# storage (credentials)
resource "google_secret_manager_secret" "nc-secret-storage-key" {
  project   = google_project.nc-project.project_id
  secret_id = "${var.nc_prefix}-storage-key"
  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
  depends_on = [google_project_service_identity.nc-project-services-identities, google_kms_crypto_key_iam_binding.nc-key-secret-binding]
}

resource "google_secret_manager_secret_version" "nc-secret-storage-key-version" {
  secret      = google_secret_manager_secret.nc-secret-storage-key.id
  secret_data = google_service_account_key.nc-service-account-key.private_key
}

# storagegw (random)
resource "random_password" "nc-secret-storagegw-value" {
  length  = 20
  upper   = true
  special = false
}

resource "google_secret_manager_secret" "nc-secret-storagegw-password" {
  project   = google_project.nc-project.project_id
  secret_id = "${var.nc_prefix}-storagegw-password"
  replication {
    user_managed {
      replicas {
        location = var.gcp_region
      }
    }
  }
  depends_on = [google_project_service_identity.nc-project-services-identities, google_kms_crypto_key_iam_binding.nc-key-secret-binding]
}

resource "google_secret_manager_secret_version" "nc-secret-storagegw-password-version" {
  secret      = google_secret_manager_secret.nc-secret-storagegw-password.id
  secret_data = random_password.nc-secret-storagegw-value.result
}

# access
data "google_iam_policy" "nc-service-account-secret-data" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:${google_service_account.nc-service-account.email}"]
  }
}

resource "google_secret_manager_secret_iam_policy" "nc-service-account-admin-secret-iam-policy" {
  project     = google_project.nc-project.project_id
  secret_id   = google_secret_manager_secret.nc-secret-admin-password.secret_id
  policy_data = data.google_iam_policy.nc-service-account-secret-data.policy_data
}

resource "google_secret_manager_secret_iam_policy" "nc-service-account-db-secret-iam-policy" {
  project     = google_project.nc-project.project_id
  secret_id   = google_secret_manager_secret.nc-secret-db-password.secret_id
  policy_data = data.google_iam_policy.nc-service-account-secret-data.policy_data
}

resource "google_secret_manager_secret_iam_policy" "nc-service-account-oo-secret-iam-policy" {
  project     = google_project.nc-project.project_id
  secret_id   = google_secret_manager_secret.nc-secret-oo-password.secret_id
  policy_data = data.google_iam_policy.nc-service-account-secret-data.policy_data
}

resource "google_secret_manager_secret_iam_policy" "nc-service-account-storage-secret-iam-policy" {
  project     = google_project.nc-project.project_id
  secret_id   = google_secret_manager_secret.nc-secret-storage-key.secret_id
  policy_data = data.google_iam_policy.nc-service-account-secret-data.policy_data
}

resource "google_secret_manager_secret_iam_policy" "nc-service-account-storagegw-secret-iam-policy" {
  project     = google_project.nc-project.project_id
  secret_id   = google_secret_manager_secret.nc-secret-storagegw-password.secret_id
  policy_data = data.google_iam_policy.nc-service-account-secret-data.policy_data
}
