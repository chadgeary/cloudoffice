# Local Deployments
`cloudoffice_raspbian.yml` and `cloudoffice_ubuntu.yml` support standalone deployments. Note OnlyOffice is not available on ARM (yet) - that includes Raspberry Pis.

# Raspbian Deployment
- Raspbian 10 (Buster)
- Tested with Raspberry Pi 3 and 4

```
# Ansible + Git
sudo apt update && sudo apt -y upgrade
sudo apt install git python3-pip
pip3 install --user --upgrade ansible

# Add .local/bin to $PATH
echo PATH="\$PATH:~/.local/bin" >> .bashrc
source ~/.bashrc

# Optionally, reboot the raspberry pi
# This may be required if the system was months out date before installing updates!
sudo reboot

# Clone the project and change to playbooks directory
git clone https://github.com/chadgeary/cloudoffice && cd cloudoffice/playbooks/

# Set Variables
web_port=443
instance_public_ip=CHANGEME
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4
docker_duckdnsupdater=172.18.1.7
project_directory=/opt

# New as of July 2021 - visit duckdns.org and get a domain + token then set your variables below
# This provides a signed, valid HTTPS certificate (instead of self-signed)
enable_duckdns=1
duckdns_domain=changeme.duckdns.org
duckdns_token=changeme-change-me-change-me
letsencrypt_email=changeme@changeme.changeme

# Want to set your own admin, database, and onlyoffice passwords instead of something randomly generated?
sudo mkdir -p /opt/nextcloud_application
echo "somepassword1" | sudo tee /opt/nextcloud_application/admin_password
echo "somepassword2" | sudo tee /opt/nextcloud_application/db_password
sudo chmod 600 /opt/nextcloud_application/admin_password
sudo chmod 600 /opt/nextcloud_application/db_password

# Execute playbook via ansible
# If your server is configured for passwordless sudo:
ansible-playbook cloudoffice_raspbian.yml --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"

# or, if your server is not configured for passwordless sudo:
ansible-playbook cloudoffice_raspbian.yml --ask-become-pass --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"

# See Playbook Summary output for WebUI URL
```

# Ubuntu Deployment
- Ubuntu 18.04 or Ubuntu 20.04

```
# Ansible + Git
sudo apt update && sudo apt -y upgrade
sudo apt install git python3-pip
pip3 install --user --upgrade ansible

# Add .local/bin to $PATH
echo PATH="\$PATH:~/.local/bin" >> .bashrc
source ~/.bashrc

# Optionally, reboot.
# This may be required if the system was months out date before installing updates!
sudo reboot

# Clone the project and change to playbooks directory
git clone https://github.com/chadgeary/cloudoffice && cd cloudoffice/playbooks/

# Set Variables
web_port=443
oo_port=8443
instance_public_ip=CHANGEME
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4
docker_onlyoffice=172.18.1.6
docker_duckdnsupdater=172.18.1.7
project_directory=/opt

# New as of July 2021 - visit duckdns.org and get a domain + token then set your variables below
# This provides a signed, valid HTTPS certificate (instead of self-signed)
enable_duckdns=1
duckdns_domain=changeme.duckdns.org
duckdns_token=changeme-change-me-change-me
letsencrypt_email=changeme@changeme.changeme

# Want to set your own admin, database, and onlyoffice passwords instead of something randomly generated?
sudo mkdir -p /opt/nextcloud_application
echo "somepassword1" | sudo tee /opt/nextcloud_application/admin_password
echo "somepassword2" | sudo tee /opt/nextcloud_application/db_password
echo "somepassword3" | sudo tee /opt/nextcloud_application/oo_password
sudo chmod 600 /opt/nextcloud_application/admin_password
sudo chmod 600 /opt/nextcloud_application/db_password
sudo chmod 600 /opt/nextcloud_application/oo_password

# Execute playbook via ansible
# If your server is configured for passwordless sudo:
ansible-playbook cloudoffice_ubuntu.yml --extra-vars="web_port=$web_port oo_port=$oo_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_onlyoffice=$docker_onlyoffice docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"

# or, if your server is not configured for passwordless sudo:
ansible-playbook cloudoffice_ubuntu.yml --ask-become-pass --extra-vars="web_port=$web_port oo_port=$oo_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_onlyoffice=$docker_onlyoffice docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"

# See Playbook Summary output for WebUI URL
```

# FAQ
- How do I update my docker containers? In rough steps:
  - Set variables
  - Remove containers
  - Re-apply ansible playbook

```
# Be in the cloudoffice/playbooks directory
cd ~/cloudoffice/playbooks

# Set customized variables (use the variables you saved previously, raspberry pis dont have oo_port or docker_onlyoffice)
web_port=443
oo_port=8443
instance_public_ip=CHANGEME
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4
docker_onlyoffice=172.18.1.6
docker_duckdnsupdater=172.18.1.7
project_directory=/opt
enable_duckdns=1
duckdns_domain=changeme.duckdns.org
duckdns_token=changeme-change-me-change-me
letsencrypt_email=changeme@changeme.changeme

# Remove old containers (service is down until Ansible completes, raspberry pis dont have cloudoffice_onlyoffice)
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_onlyoffice

# Rerun ansible-playbook, raspbian devices
ansible-playbook cloudoffice_raspbian.yml --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"

# Rerun ansible-playbook, ubuntu
ansible-playbook cloudoffice_ubuntu.yml --extra-vars="web_port=$web_port oo_port=$oo_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_onlyoffice=$docker_onlyoffice docker_duckdnsupdater=$docker_duckdnsupdater project_directory=$project_directory instance_public_ip=$instance_public_ip enable_duckdns=$enable_duckdns duckdns_domain=$duckdns_domain duckdns_token=$duckdns_token letsencrypt_email=$letsencrypt_email"
```

- Using Firefox and OnlyOffice not loading when attempting to edit/view documents?
  - Visit https://your-cloudoffice-server-ip:your-oo-port (default 8443) and accept the certificate.
