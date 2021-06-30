resource "aws_lightsail_key_pair" "nc-key" {
  name                    = "${var.name_prefix}-key"
  public_key              = var.ssh_key
}

resource "aws_lightsail_instance" "nc-instance" {
  name                    = "${var.name_prefix}-instance-${random_string.nc-random.result}"
  key_pair_name           = aws_lightsail_key_pair.nc-key.name
  availability_zone       = data.aws_availability_zones.nc-azs.names[var.aws_az]
  blueprint_id            = var.blueprint_id
  bundle_id               = var.bundle_id
  tags                    = {
    Name                    = "${var.name_prefix}-instance-${random_string.nc-random.result}"
  }
  user_data               = <<EOF
#!/bin/bash
# install ssm
sudo snap install amazon-ssm-agent --classic

# register
systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service
/snap/amazon-ssm-agent/current/amazon-ssm-agent -register -clear
/snap/amazon-ssm-agent/current/amazon-ssm-agent -register -y -id '${aws_ssm_activation.nc-ssm-activation.id}' -code '${aws_ssm_activation.nc-ssm-activation.activation_code}' -region '${var.aws_region}'
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
EOF
  depends_on              = [aws_iam_role_policy_attachment.nc-iam-attach-ssm, aws_iam_role_policy_attachment.nc-iam-attach-s3]
}

resource "aws_lightsail_static_ip" "nc-staticip" {
  name                    = "${var.name_prefix}-staticip"
}

resource "aws_lightsail_static_ip_attachment" "nc-staticipattach" {
  static_ip_name          = aws_lightsail_static_ip.nc-staticip.name
  instance_name           = aws_lightsail_instance.nc-instance.id
}
