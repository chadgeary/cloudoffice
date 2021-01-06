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
  user_data                         = "#!/bin/bash\napt-get update\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\npip3 install --upgrade ansible\nmkdir -p /opt/git/nextcloud\ngit clone ${var.project_url} /opt/git/nextcloud/\ncd /opt/git/nextcloud/\ngit pull\ncd playbooks/\nansible-playbook nextcloud_do.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_nextcloud=${var.docker_nextcloud} docker_db=${var.docker_db} docker_webproxy=${var.docker_webproxy} docker_onlyoffice=${var.docker_onlyoffice} nc_prefix=${var.nc_prefix} nc_suffix=${random_string.nc-random.result} admin_password=${var.admin_password} db_password=${var.db_password} instance_public_ip=${digitalocean_floating_ip.nc-ip.ip_address} do_region=${var.do_region} do_storageaccessid=${var.do_storageaccessid} do_storagesecretkey=${var.do_storagesecretkey} web_port=${var.web_port} project_directory=${var.project_directory}' >> /var/log/nextcloud.log"
}

resource "digitalocean_floating_ip_assignment" "nc-ip-assignment" {
  ip_address                        = digitalocean_floating_ip.nc-ip.ip_address
  droplet_id                        = digitalocean_droplet.nc-droplet.id
}
