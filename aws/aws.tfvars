## COMMON ##
# the nextcloud admin password
admin_password = "changeme"
db_password = "changeme2"

# public ssh key for instance access
ssh_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="
# ip range permitted access to instance SSH
mgmt_cidr = "a.b.c.d/32"
# an AWS IAM username (not root), creates/manages/owns encryption
kms_manager = "some_username"

## UNCOMMON ##
# aws region / instance size
aws_region = "us-east-1"
instance_type = "t3a.micro"

# The Ubuntu AMI name string, these are occasionally updated with a new date - replace us-east-1 with your region, then run the command:
# AWS_REGION=us-east-1 && ~/.local/bin/aws ec2 describe-images --region $AWS_REGION --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*' 'Name=state,Values=available' --query 'sort_by(Images, &CreationDate)[-1].Name'
vendor_ami_name_string = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201210"
vendor_ami_account_number = "099720109477"

## VERY UNCOMMON ##
# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
name_prefix = "nextcloud"
instance_vol_size = 30

# Change if ip settings would interfere with existing networks
vpc_cidr = "10.10.13.0/24"
pubnet_cidr = "10.10.13.0/26"
pubnet_instance_ip = "10.10.13.5"
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_webproxy = "172.18.1.3"
docker_db = "172.18.1.4"
