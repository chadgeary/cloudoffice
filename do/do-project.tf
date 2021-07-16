resource "digitalocean_project" "nc-project" {
  name                              = "${var.nc_prefix}-project-${random_string.nc-random.result}"
  description                       = "Nextcloud project for ${var.nc_prefix} ${random_string.nc-random.result}"
  resources                         = [digitalocean_droplet.nc-droplet.urn, digitalocean_spaces_bucket.nc-bucket.urn, digitalocean_spaces_bucket.nc-bucket-data.urn, digitalocean_floating_ip.nc-ip.urn]
} 
