## COMMON ##
# nextcloud passwords, admin username is ncadmin
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

## FREE TIER USERS ##
# Oracle configured your account for two free virtual machines in a specific cloud REGION + AD (Availability Domain), terraform needs to know these.
# See which REGION + AD oracle assigned to your account with the following two commands (without the #):

# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all

# Example output - look at each "value" and find the 2 (thats the two free virtual machines)
# The AD number is the last digit in "availability-domain" - 2 in this example (note - some regions only have one AD)
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-1",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 0
#  },
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-2",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 2
#  }

oci_region = "us-ashburn-1"
oci_adnumber = 1
oci_instance_shape = "VM.Standard.E2.1.Micro"

# Disk
# Always Free up to 200
oci_instance_diskgb = 100

# Memory and OCPUs
# Always Free VM.Standard.E2.1.Micro up to 1 OCPU and 1 MemGB
# Always Free VM.Standard.A1.Flex up to 4 OCPU and 24 MemGB but OnlyOffice is not compatible
oci_instance_ocpus = 1
oci_instance_memgb = 1

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP/Port schema might overlap ##
vcn_cidr = "10.10.12.0/24"
nc_prefix = "nextcloud"
project_url = "https://github.com/chadgeary/cloudoffice"
web_port = "443"
oo_port = "8443"
docker_network = "172.18.1.0"
docker_gw = "172.18.1.1"
docker_nextcloud = "172.18.1.2"
docker_webproxy = "172.18.1.3"
docker_db = "172.18.1.4"
docker_onlyoffice = "172.18.1.6"
