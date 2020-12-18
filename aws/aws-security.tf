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

resource "aws_security_group_rule" "nc-pubsg-mgmt-https-in" {
  security_group_id       = aws_security_group.nc-pubsg.id
  type                    = "ingress"
  description             = "IN FROM MGMT - HTTPS"
  from_port               = "443"
  to_port                 = "443"
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
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
