resource "aws_lightsail_instance_public_ports" "nc-ports" {
  instance_name           = aws_lightsail_instance.nc-instance.name
  port_info {
    protocol                = "tcp"
    from_port               = "22"
    to_port                 = "22"
    cidrs                   = [var.mgmt_cidr]
  }
  port_info {
    protocol                = "tcp"
    from_port               = var.web_port
    to_port                 = var.web_port
    cidrs                   = [var.mgmt_cidr, "${aws_lightsail_static_ip.nc-staticip.ip_address}/32"]
  }
  port_info {
    protocol                = "tcp"
    from_port               = var.oo_port
    to_port                 = var.oo_port
    cidrs                   = [var.mgmt_cidr, "${aws_lightsail_static_ip.nc-staticip.ip_address}/32"]
  }
}

