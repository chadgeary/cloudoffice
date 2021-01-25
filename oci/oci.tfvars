## COMMON ##
admin_password = "changeme1"
db_password = "changeme2"
oo_password = "changeme3"
ssh_key = "ssh-rsa AAAAchangeme"
mgmt_cidr = "1.2.3.4/32"

oci_config_profile = "/home/chad/.oci/config"
oci_root_compartment = "ocid1.tenancy.oc1..changme"

# OCI's managed Ubuntu 18.04 Minimal image, might need to be changed in the future as images are updated periodically
# See https://docs.cloud.oracle.com/en-us/iaas/images/ubuntu-1804/
# Find Canonical-Ubuntu-18.04-Minimal, click it then use the OCID of the image in your region
oci_imageid = "ocid1.image.oc1.iad.aaaaaaaascyqvxuxse7kgqtu4go2fazlxqjhq4p4p2rromclajqglaqfyhlq"

## UNCOMMON ##
# For free tier, match region and adnumber to free tier limits
# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all
oci_region = "us-ashburn-1"
oci_adnumber = 2
oci_instance_shape = "VM.Standard.E2.1.Micro"
vcn_cidr = "10.10.12.0/24"
nc_prefix = "nextcloud"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP/Port schema might overlap ##
project_url = "https://github.com/chadgeary/nextcloud"
web_port = "443"
oo_port = "8443"
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_webproxy = "172.18.1.3"
docker_db = "172.18.1.4"
docker_onlyoffice = "172.18.1.6"
