## COMMON ##
# nextcloud passwords, admin username is ncadmin
admin_password = "changeme1"
db_password    = "changeme2"
oo_password    = "changeme3"
ssh_key        = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr      = "1.2.3.4/32"

do_token            = "changeme3"
do_storageaccessid  = "changeme4"
do_storagesecretkey = "changeme5"

## UNCOMMON ##
# Note only sfo2, sfo3, nyc3, fra1, and ams3 currently support object storage
# See: https://cloud.digitalocean.com/spaces/new and https://slugs.do-api.dev/
do_region = "nyc3"
do_image  = "ubuntu-22-04-x64"

## VERY UNCOMMON ##
do_size     = "s-1vcpu-1gb"
do_cidr     = "10.10.13.0/24"
nc_prefix   = "cloudoffice"
project_url = "https://github.com/chadgeary/cloudoffice"

# Change if ip/port settings would interfere with existing networks, should all be within a /24
web_port              = "443"
oo_port               = "8443"
docker_network        = "172.18.1.0"
docker_gw             = "172.18.1.1"
docker_nextcloud      = "172.18.1.2"
docker_db             = "172.18.1.3"
docker_webproxy       = "172.18.1.4"
docker_onlyoffice     = "172.18.1.6"
docker_duckdnsupdater = "172.18.1.7"

# if using duckdns, set to 1 and fill in the complete domain, e.g.: duckdns_domain = "chadcloudoffice.duckdns.org", duckdns_token, and your email address (for letsencrypt notices)
enable_duckdns    = 0
duckdns_domain    = ""
duckdns_token     = ""
letsencrypt_email = ""
