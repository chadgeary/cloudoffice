terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "digitalocean" {
  token                    = var.do_token
  spaces_access_id         = var.do_storageaccessid
  spaces_secret_key        = var.do_storagesecretkey
}

resource "random_string" "nc-random" {
  length                            = 5
  upper                             = false
  special                           = false
}

variable "do_token" {
  type                     = string
}

variable "do_storageaccessid" {
  type                     = string
}

variable "do_storagesecretkey" {
  type                     = string
}

variable "do_region" {
  type                     = string
}

variable "ssh_key" {
  type                     = string
  description              = "A public SSH key to associate with var.ssh_user, for SSH access to the instance."
}

variable "mgmt_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation able to reach the instance via SSH, HTTPS, and (if dns_novpn = 1) DNS."
}

variable "do_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation created within the GCP project."
}

variable "admin_password" {
  type                     = string
  description              = "Nextcloud admin password"
}

variable "db_password" {
  type                     = string
  description              = "Password for nextcloud application to read/write to database"
}

variable "project_url" {
  type                     = string
  description              = "The github project URL of the playbook to run."
}

variable "do_image" {
  type                     = string
  description              = "DO image name."
}

variable "do_size" {
  type                     = string
  description              = "DO droplet size/type"
}

variable "nc_prefix" {
  type                     = string
  description              = "A (short) friendly prefix, applied to most name labels."
}

variable "docker_network" {
  type                     = string
  description              = "docker network ip"
}

variable "docker_gw" {
  type                     = string
  description              = "docker network gateway ip"
}

variable "docker_nextcloud" {
  type                     = string
  description              = "nextcloud container ip"
}

variable "docker_db" {
  type                     = string
  description              = "database container ip"
}

variable "docker_webproxy" {
  type                     = string
  description              = "https web proxy container ip"
}

variable "docker_storagegw" {
  type                     = string
  description              = "minio storage gw container ip"
}

variable "project_directory" {
  type                     = string
  description              = "Location to install/run project"
  default                  = "/opt"
}

variable "web_port" {
  type                     = string
  description              = "Port to run web proxy"
  default                  = "443"
}
