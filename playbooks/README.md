# Local Deployments
`cloudoffice_raspbian.yml` supports standalone deployments.

# Raspbian Deployment
- Raspbian 10 (Buster)
- Tested with Raspberry Pi 4

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
oo_port=8443
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4
docker_onlyoffice=172.18.1.6
project_directory=/opt

# Want to set your own admin, database, and onlyoffice passwords instead of something randomly generated?
sudo mkdir -p /opt/nextcloud
echo "somepassword1" | sudo tee /opt/nextcloud_application/admin_password
echo "somepassword2" | sudo tee /opt/nextcloud_application/db_password
echo "somepassword3" | sudo tee /opt/nextcloud_application/oo_password
sudo chmod 600 /opt/nextcloud_application/admin_password
sudo chmod 600 /opt/nextcloud_application/db_password
sudo chmod 600 /opt/nextcloud_application/oo_password

# Execute playbook via ansible
ansible-playbook cloudoffice_raspbian.yml --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_onlyoffice=$docker_onlyoffice project_directory=$project_directory"

# See Playbook Summary output for WebUI URL
```

# FAQ
- How do I update my docker containers? In rough steps:
  - Update the git project
  - Set variables
  - Remove containers
  - Re-apply ansible playbook

```
# Be in the cloudoffice/playbooks directory
cd ~/cloudoffice/playbooks

# Pull code updates
git pull

# Set customized variables
web_port=443
oo_port=8443
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4
docker_onlyoffice=172.18.1.6

# Remove old containers (service is down until Ansible completes)
sudo docker rm -f cloudoffice_nextcloud cloudoffice_database cloudoffice_webproxy cloudoffice_onlyoffice

# Rerun ansible-playbook
ansible-playbook cloudoffice_raspbian.yml --extra-vars="web_port=$web_port oo_port=$oo_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy docker_onlyoffice=$docker_onlyoffice"
```
