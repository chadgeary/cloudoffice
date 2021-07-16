terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.0.0-rc1"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  access_key               = var.scw_accesskey
  secret_key               = var.scw_secretkey
  region                   = var.scw_region
  zone                     = var.scw_zone
}

resource "random_string" "nc-random" {
  length                            = 5
  upper                             = false
  special                           = false
}

variable "scw_accesskey" {
  type                     = string
}

variable "scw_secretkey" {
  type                     = string
}

variable "scw_region" {
  type                     = string
}

variable "scw_zone" {
  type                     = string
}

variable "ssh_key" {
  type                     = string
  description              = "The public SSH key for access to the instance"
}

variable "mgmt_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation able to reach the instance via SSH, HTTPS, and (if dns_novpn = 1) DNS."
}

variable "scw_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation created within the project."
}

variable "admin_password" {
  type                     = string
  description              = "Nextcloud admin password"
}

variable "db_password" {
  type                     = string
  description              = "Password for nextcloud application to read/write to database"
}

variable "oo_password" {
  type                     = string
  description              = "Password for nextcloud application to talk with onlyoffice"
}

variable "project_url" {
  type                     = string
  description              = "The github project URL of the playbook to run."
}

variable "scw_image" {
  type                     = string
  description              = "DO image name."
}

variable "scw_size" {
  type                     = string
  description              = "instance size/type"
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

variable "docker_onlyoffice" {
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

variable "oo_port" {
  type                     = string
  description              = "Port to run web proxy"
  default                  = "8443"
}

variable "enable_duckdns" {
  type                    = number
}

variable "duckdns_domain" {
  type                    = string
}

variable "duckdns_token" {
  type                    = string
}

variable "letsencrypt_email" {
  type                    = string
}
