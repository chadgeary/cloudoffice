# Instance Key
resource "aws_key_pair" "nc-instance-key" {
  key_name   = "nc-ssh-pub-key-${random_string.nc-random.result}"
  public_key = var.ssh_key
  tags = {
    Name = "nc-ssh-pub-key-${random_string.nc-random.result}"
  }
}

# Instance(s)
resource "aws_instance" "nc-instance" {
  ami                    = aws_ami_copy.nc-latest-vendor-ami-with-cmk.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.nc-instance-profile.name
  key_name               = aws_key_pair.nc-instance-key.key_name
  subnet_id              = aws_subnet.nc-pubnet.id
  private_ip             = var.pubnet_instance_ip
  vpc_security_group_ids = [aws_security_group.nc-pubsg.id]
  tags = {
    Name = "${var.name_prefix}-instance-${random_string.nc-random.result}",
  }
  root_block_device {
    volume_size = var.instance_vol_size
    volume_type = "standard"
    encrypted   = "true"
    kms_key_id  = aws_kms_key.nc-kmscmk-ec2.arn
  }
  depends_on = [aws_iam_role_policy_attachment.nc-iam-attach-ssm, aws_iam_role_policy_attachment.nc-iam-attach-s3]
}

# Elastic IP for Instance(s)
resource "aws_eip" "nc-eip" {
  vpc                       = true
  instance                  = aws_instance.nc-instance.id
  associate_with_private_ip = var.pubnet_instance_ip
  depends_on                = [aws_internet_gateway.nc-gw]
}
