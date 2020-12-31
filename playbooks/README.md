# Local Deployments
`nextcloud_raspbian.yml` supports standalone deployments.

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
git clone https://github.com/chadgeary/nextcloud && cd nextcloud/playbooks/

# Set Variables
web_port=443
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4

# Want to set your own ncadmin and ncdb passwords instead of something randomly generated?
sudo mkdir -p /opt/nextcloud
echo "somepassword1" | sudo tee /opt/nextcloud/ncadmin_password
echo "somepassword2" | sudo tee /opt/nextcloud/ncdb_password
sudo chmod 600 /opt/nextcloud/ncadmin_password
sudo chmod 600 /opt/nextcloud/ncdb_password

# Execute playbook via ansible
ansible-playbook nextcloud_raspbian.yml --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy"

# See Playbook Summary output for WebUI URL
```

# FAQ
- How do I update my docker containers? In rough steps:
  - Update the git project
  - Set variables
  - Remove containers
  - Re-apply ansible playbook

```
# Be in the nextcloud/playbooks directory
cd ~/nextcloud/playbooks

# Pull code updates
git pull

# Set customized variables
web_port=443
docker_network=172.18.1.0
docker_gw=172.18.1.1
docker_nextcloud=172.18.1.2
docker_db=172.18.1.3
docker_webproxy=172.18.1.4

# Remove old containers (service is down until Ansible completes)
sudo docker rm -f nextcloud_application nextcloud_database nextcloud_webproxy

# Rerun ansible-playbook
ansible-playbook nextcloud_raspbian.yml --extra-vars="web_port=$web_port docker_network=$docker_network docker_gw=$docker_gw docker_nextcloud=$docker_nextcloud docker_db=$docker_db docker_webproxy=$docker_webproxy"
```
