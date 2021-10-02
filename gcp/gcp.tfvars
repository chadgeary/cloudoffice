## COMMON ##
# nextcloud passwords, admin username is ncadmin
admin_password = "changeme1"
db_password    = "changeme2"
oo_password    = "changeme3"
ssh_key        = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr      = "1.2.3.4/32"

gcp_billing_account = "X1X1X1-ABABAB-123456"
gcp_user            = "me@example.com"

## UNCOMMON ##
gcp_region = "us-east1"
gcp_zone   = "b"

# Ubuntu occasionally updates the base image, use the following command to see the latest image name
# gcloud compute images list --project ubuntu-os-cloud --filter="family=('ubuntu-1804-lts')" --format="value('NAME')"
gcp_image_name    = "ubuntu-1804-bionic-v20201014"
gcp_image_project = "ubuntu-os-cloud"

## VERY UNCOMMON ##
nc_prefix            = "nextcloud"
gcp_machine_type     = "e2-micro"
disk_gb              = 30
project_url          = "https://github.com/chadgeary/cloudoffice"
gcp_project_services = ["serviceusage.googleapis.com", "cloudkms.googleapis.com", "storage-api.googleapis.com", "secretmanager.googleapis.com"]
ssh_user             = "ubuntu"
gcp_cidr             = "10.10.13.0/24"
gcp_instanceip       = "10.10.13.5"

# Change if ip settings would interfere with existing networks/ports, should all be within a /24
web_port              = "443"
oo_port               = "8443"
docker_network        = "172.18.1.0"
docker_gw             = "172.18.1.1"
docker_nextcloud      = "172.18.1.2"
docker_db             = "172.18.1.3"
docker_webproxy       = "172.18.1.4"
docker_storagegw      = "172.18.1.5"
docker_onlyoffice     = "172.18.1.6"
docker_duckdnsupdater = "172.18.1.7"

# if using duckdns, set to 1 and fill in the complete domain, e.g.: duckdns_domain = "chadcloudoffice.duckdns.org", duckdns_token, and your email address (for letsencrypt notices)
enable_duckdns    = 0
duckdns_domain    = ""
duckdns_token     = ""
letsencrypt_email = ""
