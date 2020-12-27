## COMMON ##
admin_password = "changeme1"
db_password = "changeme2"
ssh_key = "ssh-rsa AAAAB3replace_me_replace_me_replace_me"
mgmt_cidr = "1.2.3.4/32"

gcp_billing_account = "X1X1X1-ABABAB-123456"
gcp_user = "me@example.com"

## UNCOMMON ##
# At the time of this guide, only us-west1, us-central1, and us-east1 are always-free compatible
gcp_region = "us-east1"
gcp_zone = "b"

# Ubuntu occasionally updates the base image, use the following command to see the latest image name
# gcloud compute images list --project ubuntu-os-cloud --filter="family=('ubuntu-1804-lts')" --format="value('NAME')"
gcp_image_name = "ubuntu-1804-bionic-v20201014"
gcp_image_project = "ubuntu-os-cloud"

## VERY UNCOMMON ##
nc_prefix = "nextcloud"
gcp_machine_type = "f1-micro"
disk_gb = 30
project_url = "https://github.com/chadgeary/nextcloud"
gcp_project_services = ["serviceusage.googleapis.com","cloudkms.googleapis.com","storage-api.googleapis.com","secretmanager.googleapis.com"]
ssh_user = "ubuntu"
gcp_cidr = "10.10.13.0/24"
gcp_instanceip = "10.10.13.5"

# Change if ip settings would interfere with existing networks, should all be within a /24
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_db = "172.18.1.3"
docker_webproxy = "172.18.1.4"
docker_storagegw = "172.18.1.5"
