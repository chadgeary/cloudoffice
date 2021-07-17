## COMMON ##
# nextcloud passwords, admin username is ncadmin
admin_password = "changeme1"
db_password = "changeme2"
oo_password = "changeme3"
ssh_key = "ssh-rsa AAAAchangeme"
mgmt_cidr = "1.2.3.4/32"

oci_config_profile = "/home/chad/.oci/config"
oci_root_compartment = "ocid1.tenancy.oc1..changme"

# Use a recent version of OCI's managed Ubuntu 20.04 image - specific to your region.
# For the latest Ubuntu image ids in your region, run:
# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]") && oci compute image list --compartment-id $OCI_TENANCY_OCID --all --lifecycle-state 'AVAILABLE' --operating-system "Canonical Ubuntu" --operating-system-version "20.04" --sort-by "TIMECREATED" | grep 'display-name\|ocid'

# For ARM instances, choose the AARCH64 ocid in the command above
oci_imageid = "ocid1.image.oc1.iad.aaaaaaaatw7xix4fave3xik3ukrgvwl7eihmrfqczj5la6uvji3te56fo5bq"

## FREE TIER USERS ##
# Oracle configured your account for two free AMD64 virtual machines (and ARM now!) in a specific cloud REGION + AD (Availability Domain), terraform needs to know these.
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

# For ARM, use VM.Standard.A1.Flex
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
docker_duckdnsupdater = "172.18.1.7"

# if using duckdns, set to 1 and fill in the complete domain, e.g.: duckdns_domain = "chadcloudoffice.duckdns.org", duckdns_token, and your email address (for letsencrypt notices)
enable_duckdns = 0
duckdns_domain = ""
duckdns_token = ""
letsencrypt_email = ""
