resource "local_file" "nc_init" {
  filename                          = "${var.nc_prefix}-init-${random_string.nc-random.result}.yml"
  content                           = <<FILECONTENT
#cloud-config for cloudoffice on scw (scaleway)
runcmd:
  - [ bash, -c, "apt-get update" ]
  - [ bash, -c, "DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git" ]
  - [ bash, -c, "pip3 install --upgrade pip && pip3 install --upgrade ansible" ]
  - [ bash, -c, "mkdir -p /opt/git/cloudoffice && git clone ${var.project_url} /opt/git/cloudoffice; cd /opt/git/cloudoffice; git pull" ]
  - [ bash, -c, "cd /opt/git/cloudoffice/playbooks/ && ansible-playbook cloudoffice_do_bootstrap.yml >> /var/log/cloudoffice-bootstrap.log" ]
FILECONTENT
}

resource "local_file" "nc_setup" {
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
# pip update pip
pip3 install --upgrade pip
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
ansible-playbook cloudoffice_scw.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_onlyoffice=${var.docker_onlyoffice} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} admin_password=${var.admin_password} db_password=${var.db_password} oo_password=${var.oo_password} instance_public_ip=${scaleway_instance_ip.nc-ip.address} scw_region=${var.scw_region} scw_accesskey=${var.scw_accesskey} scw_secretkey=${var.scw_secretkey} backup_endpoint=${scaleway_object_bucket.nc-backup-bucket.endpoint} data_endpoint=${scaleway_object_bucket.nc-data-bucket.endpoint} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory}' >> /var/log/cloudoffice.log
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
