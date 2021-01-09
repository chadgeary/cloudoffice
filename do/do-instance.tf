resource "digitalocean_ssh_key" "nc-sshkey" {
  name                              = "${var.nc_prefix}-sshkey-${random_string.nc-random.result}"
  public_key                        = var.ssh_key
}

resource "digitalocean_floating_ip" "nc-ip" {
  region                            = var.do_region
}

resource "digitalocean_droplet" "nc-droplet" {
  name                              = "${var.nc_prefix}-instance-${random_string.nc-random.result}"
  region                            = var.do_region
  private_networking                = "true"
  vpc_uuid                          = digitalocean_vpc.nc-network.id
  image                             = var.do_image
  size                              = var.do_size
  ssh_keys                          = [digitalocean_ssh_key.nc-sshkey.fingerprint]
  user_data                         = "#!/bin/bash\n# Create systemd service unit file\ntee /etc/systemd/system/cloudoffice-ansible-state.service << EOM\n[Unit]\nDescription=cloudoffice-ansible-state\nAfter=network.target\n\n[Service]\nExecStart=/opt/cloudoffice-ansible-state.sh\nType=simple\nRestart=on-failure\nRestartSec=30\n\n[Install]\nWantedBy=multi-user.target\nEOM\n\n# Create systemd timer unit file\ntee /etc/systemd/system/cloudoffice-ansible-state.timer << EOM\n[Unit]\nDescription=Starts cloudoffice ansible state playbook 1min after boot\n\n[Timer]\nOnBootSec=1min\nUnit=cloudoffice-ansible-state.service\n\n[Install]\nWantedBy=multi-user.target\nEOM\n\n# Create cloudoffice-ansible-state script\ntee /opt/cloudoffice-ansible-state.sh << EOM\n#!/bin/bash\n# Update package list\napt-get update\n# Install pip3 and git\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\n# Install azure for ansible\npip3 install --upgrade ansible\n# Make the project directory\nmkdir -p /opt/git/cloudoffice\n# Clone project into project directory\ngit clone ${project_url} /opt/git/cloudoffice\n# Change to directory\ncd /opt/git/cloudoffice\n# Ensure up-to-date\ngit pull\n# Change to playbooks directory\ncd playbooks/\n# Execute playbook\nansible-playbook cloudoffice_do.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_onlyoffice=${var.docker_onlyoffice} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} admin_password=${var.admin_password} db_password=${var.db_password} oo_password=${var.oo_password} instance_public_ip=${digitalocean_floating_ip.nc-ip.ip_address} do_region=${var.do_region} do_storageaccessid=${var.do_storageaccessid} do_storagesecretkey=${var.do_storagesecretkey} web_port=${var.web_port} oo_port=${var.oo_port} project_directory=${var.project_directory}' >> /var/log/cloudoffice.log\nEOM\n\n# Start / Enable cloudoffice-ansible-state\nchmod +x /opt/cloudoffice-ansible-state.sh\nsystemctl daemon-reload\nsystemctl start cloudoffice-ansible-state.timer\nsystemctl start cloudoffice-ansible-state.service\nsystemctl enable cloudoffice-ansible-state.timer\nsystemctl enable cloudoffice-ansible-state.service"
}

resource "digitalocean_floating_ip_assignment" "nc-ip-assignment" {
  ip_address                        = digitalocean_floating_ip.nc-ip.ip_address
  droplet_id                        = digitalocean_droplet.nc-droplet.id
}
