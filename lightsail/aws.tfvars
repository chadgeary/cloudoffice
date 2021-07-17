## COMMON ##
# nextcloud passwords, admin username is ncadmin
admin_password = "changeme1"
db_password = "changeme2"
oo_password = "changeme3"

# public ssh key for instance access
ssh_key = "ssh-rsa AAAAB3NzaC1ychange_me_change_me_change_me="
# ip range permitted access to instance SSH and WebUI
mgmt_cidr = "a.b.c.d/32"
# an AWS IAM username (not root), creates/manages/owns encryption
kms_manager = "some_username"

## UNCOMMON ##
# aws region / instance size - strongly recommend 1GB+ of memory
aws_region = "us-east-1"

# pick an availability zone, 0 = a, 1 = b, 2 = c, etc.
aws_az = 0

# lightsail uses "bundles and blueprints" instead of instance typesi and AMIs - see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance#bundles and https://aws.amazon.com/lightsail/pricing/
# attempting to use nano may or may not succeed, good luck!
bundle_id = "micro_2_0"
blueprint_id = "ubuntu_20_04"

# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
name_prefix = "cloudoffice"
web_port = "443"
oo_port = "8443"

# Change if ip settings would interfere with existing networks
vpc_cidr = "10.10.13.0/24"
pubnet_cidr = "10.10.13.0/26"
pubnet_instance_ip = "10.10.13.5"
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_db = "172.18.1.3"
docker_webproxy = "172.18.1.4"
docker_onlyoffice = "172.18.1.6"
docker_duckdnsupdater = "172.18.1.7"

# if using duckdns, set to 1 and fill in the complete domain, e.g.: duckdns_domain = "chadcloudoffice.duckdns.org", duckdns_token, and your email address (for letsencrypt notices)
enable_duckdns = 0
duckdns_domain = ""
duckdns_token = ""
letsencrypt_email = ""
