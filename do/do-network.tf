resource "digitalocean_vpc" "nc-network" {
  name                              = "${var.nc_prefix}-network-${random_string.nc-random.result}"
  region                            = var.do_region
  ip_range                          = var.do_cidr
}

resource "digitalocean_firewall" "nc-firewall" {
  count                             = var.enable_duckdns == 0 ? 1 : 0
  name                              = "${var.nc_prefix}-firewall-${random_string.nc-random.result}"
  droplet_ids                       = [digitalocean_droplet.nc-droplet.id]
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "22"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = var.web_port
    source_addresses                  = [var.mgmt_cidr, digitalocean_floating_ip.nc-ip.ip_address]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = var.oo_port
    source_addresses                  = [var.mgmt_cidr, digitalocean_floating_ip.nc-ip.ip_address]
  }
  outbound_rule {
    protocol                          = "tcp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "udp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
}

resource "digitalocean_firewall" "nc-firewall-duckdns" {
  count                             = var.enable_duckdns == 1 ? 1 : 0
  name                              = "${var.nc_prefix}-firewall-${random_string.nc-random.result}"
  droplet_ids                       = [digitalocean_droplet.nc-droplet.id]
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "22"
    source_addresses                  = [var.mgmt_cidr]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = var.web_port
    source_addresses                  = [var.mgmt_cidr, digitalocean_floating_ip.nc-ip.ip_address]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = var.oo_port
    source_addresses                  = [var.mgmt_cidr, digitalocean_floating_ip.nc-ip.ip_address]
  }
  inbound_rule {
    protocol                          = "tcp"
    port_range                        = "80"
    source_addresses                  = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "tcp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol                          = "udp"
    port_range                        = "1-65535"
    destination_addresses             = ["0.0.0.0/0"]
  }
}
