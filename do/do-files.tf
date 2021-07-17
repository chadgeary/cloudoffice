resource "local_file" "do_setup" {
  filename                          = "${var.nc_prefix}-setup-${random_string.nc-random.result}.sh"
  content                           = <<FILECONTENT
# Create systemd service unit file
sudo tee /etc/systemd/system/cloudoffice-ansible-state.service << EOM
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
sudo tee /etc/systemd/system/cloudoffice-ansible-state.timer << EOM
[Unit]
Description=Starts cloudoffice ansible state playbook 1min after boot

[Timer]
OnBootSec=1mi
nUnit=cloudoffice-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create cloudoffice-ansible-state script
sudo tee /opt/cloudoffice-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Install ansible
pip3 install --upgrade ansible
# Make the project directory
mkdir -p /opt/git/cloudoffice
# Clone project into project directory
git clone ${var.project_url} /opt/git/cloudoffice
# Change to directory
cd /opt/git/cloudoffice
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook cloudoffice_do.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_onlyoffice=${var.docker_onlyoffice} docker_duckdnsupdater=${var.docker_duckdnsupdater} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} admin_password=${var.admin_password} db_password=${var.db_password} oo_password=${var.oo_password} instance_public_ip=${digitalocean_floating_ip.nc-ip.ip_address} do_region=${var.do_region} do_storageaccessid=${var.do_storageaccessid} do_storagesecretkey=${var.do_storagesecretkey} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory} enable_duckdns=${var.enable_duckdns} duckdns_domain=${var.duckdns_domain} duckdns_token=${var.duckdns_token} letsencrypt_email=${var.letsencrypt_email}' >> /var/log/cloudoffice.log
EOM

# Start / Enable cloudoffice-ansible-state
sudo chown root:root /opt/cloudoffice-ansible-state.sh
sudo chmod 500 /opt/cloudoffice-ansible-state.sh
sudo systemctl daemon-reload
sudo systemctl start cloudoffice-ansible-state.service
sudo systemctl enable cloudoffice-ansible-state.timer
sudo systemctl enable cloudoffice-ansible-state.service
  FILECONTENT
}
