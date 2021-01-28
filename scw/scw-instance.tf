resource "scaleway_instance_ip" "nc-ip" {
}

resource "scaleway_instance_server" "nc-instance" {
  name                              = "${var.nc_prefix}-instance-${random_string.nc-random.result}"
  type                              = var.scw_size
  image                             = var.scw_image
  ip_id                             = scaleway_instance_ip.nc-ip.id
  security_group_id                 = scaleway_instance_security_group.nc-securitygroup.id
  user_data = {
    cloud-init                        = file("${path.module}/${local_file.nc_init.filename}")
  }
}
