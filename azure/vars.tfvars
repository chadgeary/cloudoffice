## COMMON ##

## UNCOMMON ##
# An azure region (and zone), use the following command for a list of region names (use the varsfile value):
# az account list-locations --query "[?metadata.regionType=='Physical'].{varsfile:displayName, cli:name}" --output table
az_region = "West Europe"
az_zone   = "1"

# The version of Ubuntu 1804 to use, use the following command to see the latest official version (replace centralus with the previous command's cli column name
# az vm image show --location "centralus" --urn Canonical:UbuntuServer:18.04-LTS:latest --query name --output table
az_image_version = "18.04.202107200"

# free tier
az_vm_size = "Standard_B1s"
az_disk_gb = 64
# nc_prefix can only consist of lowercase letters and numbers, and should be <=10 characters
nc_prefix       = "nextcloud"
az_network_cidr = "10.10.10.0/24"
az_subnet_cidr  = "10.10.10.0/26"
ssh_user        = "ubuntu"

## VERY UNCOMMON ##
# Change if using a cloned / separate git project or ip settings would interfere with existing networks
project_url = "https://github.com/JCZuurmond/cloudoffice"

# Change if ip/port settings would interfere with existing networks, should all be within a /24
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
enable_duckdns    = 1
letsencrypt_email = "jczuurmond@protonmail.com"
