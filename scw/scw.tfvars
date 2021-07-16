## COMMON ##
# nextcloud passwords, admin username is ncadmin
admin_password = "changeme1"
db_password = "changeme2"
oo_password = "changeme3"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

scw_accesskey = "changeme3"
scw_secretkey = "changeme4"

# Ensure the region/zone has the instance type available!
# See: https://console.scaleway.com/instance/servers/create
# and see: https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/guides/regions_and_zones
scw_region = "nl-ams"
scw_zone = "nl-ams-1"
scw_image = "ubuntu_bionic"
scw_size = "STARDUST1-S"
web_port = "443"

## UNCOMMON ##
nc_prefix = "cloudoffice"
project_url = "https://github.com/chadgeary/cloudoffice"

# Change if ip/port settings would interfere with existing scw networks, local networks, or container networks
scw_cidr = "10.10.13.0/24"
oo_port = "8443"
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_db = "172.18.1.3"
docker_webproxy = "172.18.1.4"
docker_onlyoffice = "172.18.1.6"

# if using duckdns, set to 1 and fill in the complete domain, e.g.: duckdns_domain = "chadcloudoffice.duckdns.org", duckdns_token, and your email address (for letsencrypt notices)
enable_duckdns = 0
duckdns_domain = ""
duckdns_token = ""
letsencrypt_email = ""
