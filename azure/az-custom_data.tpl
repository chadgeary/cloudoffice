#!/bin/bash
# Create systemd service unit file
tee /etc/systemd/system/nextcloud-ansible-state.service << EOM
[Unit]
Description=nextcloud-ansible-state
After=network.target

[Service]
ExecStart=/opt/nextcloud-ansible-state.sh
Type=simple
Restart=on-failure   
RestartSec=30

[Install]
WantedBy=multi-user.target
EOM

# Create systemd timer unit file
tee /etc/systemd/system/nextcloud-ansible-state.timer << EOM
[Unit]
Description=Starts nextcloud ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=nextcloud-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create nextcloud-ansible-state script
tee /opt/nextcloud-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Install azure for ansible
pip3 install ansible[azure]
# And the collection
ansible-galaxy collection install azure.azcollection
# Grab the python requirements for azure
rm -f requirements-azure.txt
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
# Install the requirements
pip3 install -r requirements-azure.txt
# Make the project directory
mkdir -p /opt/git/nextcloud
# Clone project into project directory
git clone ${project_url} /opt/git/nextcloud
# Change to directory
cd /opt/git/nextcloud
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook nextcloud_azure.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_nextcloud=${docker_nextcloud} docker_db=${docker_db} docker_webproxy=${docker_webproxy} docker_storagegw=${docker_storagegw} nc_prefix=${nc_prefix} nc_suffix=${nc_suffix} instance_public_ip=${instance_public_ip}' >> /var/log/nextcloud.log
EOM

# Start / Enable nextcloud-ansible-state
chmod +x /opt/nextcloud-ansible-state.sh
systemctl daemon-reload
systemctl start nextcloud-ansible-state.timer
systemctl start nextcloud-ansible-state.service
systemctl enable nextcloud-ansible-state.timer
systemctl enable nextcloud-ansible-state.service
