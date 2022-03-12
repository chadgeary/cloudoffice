resource "digitalocean_ssh_key" "nc-sshkey" {
  name       = "${var.nc_prefix}-sshkey-${random_string.nc-random.result}"
  public_key = var.ssh_key
}

resource "digitalocean_droplet" "nc-droplet" {
  name               = "${var.nc_prefix}-instance-${random_string.nc-random.result}"
  region             = var.do_region
  vpc_uuid           = digitalocean_vpc.nc-network.id
  image              = var.do_image
  size               = var.do_size
  ssh_keys           = [digitalocean_ssh_key.nc-sshkey.fingerprint]
  user_data          = "#!/bin/bash\n# Update package list\napt-get update\n# Install pip3 and git\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\n# Install ansible\npip3 install --upgrade ansible\n# Make the project directory\nmkdir -p /opt/git/cloudoffice\n# Clone project into project directory\ngit clone ${var.project_url} /opt/git/cloudoffice\n# Change to directory\ncd /opt/git/cloudoffice\n# Ensure up-to-date\ngit pull\n# Change to playbooks directory\ncd playbooks/\n# Execute playbook\nansible-playbook cloudoffice_do_bootstrap.yml >> /var/log/cloudoffice.log\n"
}
