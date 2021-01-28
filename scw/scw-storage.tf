resource "scaleway_object_bucket" "nc-backup-bucket" {
  name                              = "${var.nc_prefix}-backup-bucket-${random_string.nc-random.result}"
  acl                               = "private"
  region                            = var.scw_region
}

resource "scaleway_object_bucket" "nc-data-bucket" {
  name                              = "${var.nc_prefix}-data-bucket-${random_string.nc-random.result}"
  acl                               = "private"
  region                            = var.scw_region
}
