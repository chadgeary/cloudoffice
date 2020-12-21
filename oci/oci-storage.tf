data "oci_objectstorage_namespace" "nc-bucket-namespace" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
}

resource "oci_objectstorage_bucket" "nc-bucket" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  name                    = "${var.nc_prefix}-bucket"
  namespace               = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
  kms_key_id              = oci_kms_key.nc-kms-storage-key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Enabled"
}

resource "oci_objectstorage_bucket" "nc-bucket-data" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  name                    = "${var.nc_prefix}-bucket-data"
  namespace               = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
  kms_key_id              = oci_kms_key.nc-kms-storage-key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Enabled"
}

resource "oci_objectstorage_object_lifecycle_policy" "nc-bucket-lifecycle" {
  bucket                  = oci_objectstorage_bucket.nc-bucket.name
  namespace               = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
  rules {
    action                  = "DELETE"
    is_enabled              = "true"
    name                    = "${var.nc_prefix} lifecycle policy"
    object_name_filter {
      inclusion_prefixes      = ["nextcloud/"]
    }
    target                  = "previous-object-versions"
    time_amount             = 7
    time_unit               = "DAYS"
  }
  depends_on              = [oci_identity_policy.nc-id-storageobject-policy]
}
