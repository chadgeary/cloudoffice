## COMMON ##
admin_password = "changeme1"
db_password = "changeme2"
ssh_key = "ssh-rsa AAAAchangeme_changeme_changeme_changemexUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu1gya2wMLeo1rBJFcb6ZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6RSAltLROUONn0SF2BvvJUueqxpAIaA2rU4MSI69P"
mgmt_cidr = "1.2.3.4/32"

## UNCOMMON ##
# An azure region (and zone), use the following command for a list of region names (use the varsfile value):
# az account list-locations --query "[?metadata.regionType=='Physical'].{varsfile:displayName, cli:name}" --output table
az_region = "East US"
az_zone = "1"

# The version of Ubuntu 1804 to use, use the following command to see the latest official version (replace centralus with the previous command's cli column name
# az vm image show --location "centralus" --urn Canonical:UbuntuServer:18.04-LTS:latest --query name --output table
az_image_version = "18.04.202010140"

# free tier
az_vm_size = "Standard_B1s"
az_disk_gb = 64
# nc_prefix can only consist of lowercase letters and numbers, and should be <=10 characters
nc_prefix = "nextcloud"
az_network_cidr = "10.10.10.0/24"
az_subnet_cidr = "10.10.10.0/26"
ssh_user = "ubuntu"

## VERY UNCOMMON ##
# Change if using a cloned / separate git project or ip settings would interfere with existing networks
project_url = "https://github.com/chadgeary/nextcloud"

# Change if ip settings would interfere with existing networks, should all be within a /24
docker_network = "172.18.0.0"
docker_gw = "172.18.0.1"
docker_nextcloud = "172.18.0.2"
docker_db = "172.18.0.3"
docker_webproxy = "172.18.0.4"
