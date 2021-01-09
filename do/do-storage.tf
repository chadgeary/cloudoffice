resource "digitalocean_spaces_bucket" "nc-bucket" {
  name                              = "${var.nc_prefix}-bucket-${random_string.nc-random.result}"
  region                            = var.do_region
  versioning {
    enabled                           = "false"
  }
}

resource "digitalocean_spaces_bucket" "nc-bucket-data" {
  name                              = "${var.nc_prefix}-bucket-data-${random_string.nc-random.result}"
  region                            = var.do_region
  versioning {
    enabled                           = "false"
  }
}
