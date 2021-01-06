## COMMON ##
admin_password = "changeme1"
db_password = "changeme2"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

do_token = "changeme3"
do_storageaccessid = "changeme4"
do_storagesecretkey = "changeme5"

## UNCOMMON ##
do_region = "nyc3"
do_image = "ubuntu-18-04-x64"

## VERY UNCOMMON ##
do_size = "s-1vcpu-1gb"
do_cidr = "10.10.13.0/24"
nc_prefix = "nextcloud"
project_url = "https://github.com/chadgeary/nextcloud"

# Change if ip settings would interfere with existing networks, should all be within a /24
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_db = "172.18.1.3"
docker_webproxy = "172.18.1.4"
docker_onlyoffice = "172.18.1.6"
