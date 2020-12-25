provider "google" {
  region                   = var.gcp_region
}

variable "gcp_region" {
  type                     = string
}

variable "gcp_zone" {
  type                     = string
  description              = "The letter-code for a region's zone, e.g. b in us-east1-b"
}

variable "gcp_user" {
  type                     = string
}

variable "ssh_user" {
  type                     = string
  description              = "The user to associate with the SSH key. Default: ubuntu"
}

variable "ssh_key" {
  type                     = string
  description              = "A public SSH key to associate with var.ssh_user, for SSH access to the instance."
}

variable "mgmt_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation able to reach the instance via SSH, HTTPS, and (if dns_novpn = 1) DNS."
}

variable "gcp_cidr" {
  type                     = string
  description              = "The subnet in CIDR notation created within the GCP project."
}

variable "gcp_instanceip" {
  type                     = string
  description              = "An IP within the gcp_cidr subnet for the GCP instance."
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

variable "gcp_billing_account" {
  type                     = string
  description              = "The GCP billing account ID"
}

variable "gcp_project_services" {
  type                     = list(string)
  description              = "The service APIs to enable under the project"
}

variable "gcp_image_project" {
  type                     = string
  description              = "Project name where the image resides."
}

variable "gcp_image_name" {
  type                     = string
  description              = "The name of the Ubuntu (18.04 tested) image."
}

variable "gcp_machine_type" {
  type                     = string
  description              = "Instance size/type"
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
