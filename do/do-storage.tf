resource "digitalocean_spaces_bucket" "nc-bucket" {
  name                              = "${var.nc_prefix}-bucket-${random_string.nc-random.result}"
  region                            = var.do_region
  versioning {
    enabled                           = "true"
  }
  lifecycle_rule {
    enabled                           = "true"
    noncurrent_version_expiration {
      days                            = 7
    }
    expiration {
      expired_object_delete_marker    = "true"
    }
  }
}

resource "digitalocean_spaces_bucket" "nc-bucket-data" {
  name                              = "${var.nc_prefix}-bucket-data-${random_string.nc-random.result}"
  region                            = var.do_region
  versioning {
    enabled                           = "false"
  }
}
