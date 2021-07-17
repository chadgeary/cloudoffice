#!/bin/bash
# Create systemd service unit file
tee /etc/systemd/system/cloudoffice-ansible-state.service << EOM
[Unit]
Description=cloudoffice-ansible-state
After=network.target

[Service]
ExecStart=/opt/cloudoffice-ansible-state.sh
Type=simple
Restart=on-failure   
RestartSec=30

[Install]
WantedBy=multi-user.target
EOM

# Create systemd timer unit file
tee /etc/systemd/system/cloudoffice-ansible-state.timer << EOM
[Unit]
Description=Starts cloudoffice ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=cloudoffice-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create cloudoffice-ansible-state script
tee /opt/cloudoffice-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
pip3 install --upgrade pip
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
mkdir -p /opt/git/cloudoffice
# Clone project into project directory
git clone ${project_url} /opt/git/cloudoffice
# Change to directory
cd /opt/git/cloudoffice
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook cloudoffice_azure.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_nextcloud=${docker_nextcloud} docker_db=${docker_db} docker_webproxy=${docker_webproxy} docker_storagegw=${docker_storagegw} docker_onlyoffice=${docker_onlyoffice} nc_prefix=${nc_prefix} nc_suffix=${nc_suffix} instance_public_ip=${instance_public_ip} az_storage_account_name=${az_storage_account_name} web_port=${web_port} oo_port=${oo_port} project_directory=${project_directory} enable_duckdns=${enable_duckdns} duckdns_domain=${duckdns_domain} duckdns_token=${duckdns_token} letsencrypt_email=${letsencrypt_email} docker_duckdnsupdater=${docker_duckdnsupdater}' >> /var/log/cloudoffice.log
EOM

# Start / Enable cloudoffice-ansible-state
chmod +x /opt/cloudoffice-ansible-state.sh
systemctl daemon-reload
systemctl start cloudoffice-ansible-state.timer
systemctl start cloudoffice-ansible-state.service
systemctl enable cloudoffice-ansible-state.timer
systemctl enable cloudoffice-ansible-state.service
