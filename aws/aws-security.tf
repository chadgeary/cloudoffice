# security groups
resource "aws_security_group" "nc-pubsg" {
  name                    = "nc-pubsg"
  description             = "Security group for public traffic"
  vpc_id                  = aws_vpc.nc-vpc.id
  tags = {
    Name = "nc-pubsg"
  }
}

# public sg rules
resource "aws_security_group_rule" "nc-pubsg-mgmt-ssh-in" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM MGMT - SSH MGMT"
  from_port               = "22"
  to_port                 = "22"
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "nc-pubsg-mgmt-web-in" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM MGMT - WEB"
  from_port               = var.web_port
  to_port                 = var.web_port
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "nc-pubsg-mgmt-oo-in" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM MGMT AND SELF - OO"
  from_port               = var.oo_port
  to_port                 = var.oo_port
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr, "${aws_eip.nc-eip.public_ip}/32"]
}

resource "aws_security_group_rule" "nc-pubsg-out-tcp" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "egress"
  description             = "OUT TO WORLD - TCP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nc-pubsg-out-udp" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "egress"
  description             = "OUT TO WORLD - UDP"
  from_port               = 0
  to_port                 = 65535
  protocol                = "udp"
  cidr_blocks             = ["0.0.0.0/0"]
}
