terraform {
  # Backend variables are initialized by CI
  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "nc-client-conf" {
}

data "azurerm_subscription" "nc-subscription" {
}

data "azurerm_key_vault" "terraform" {
  resource_group_name = var.terraform_resource_group_name
  name                = var.terraform_key_vault_name
}

data "azurerm_key_vault_secret" "duckdns_token" {
  name         = "duckdns-token"
  key_vault_id = data.azurerm_key_vault.terraform.id
}

resource "random_string" "nc-random" {
  length  = 5
  upper   = false
  special = false
}

variable "az_region" {
  type        = string
  description = "Region to deploy services in"
}

variable "az_zone" {
  type        = string
  description = "An availability zone in a region, e.g. 1"
}

variable "az_image_version" {
  type        = string
  description = "The version of Canonical's Ubuntu 18_04-lts-gen2 azure image"
}

variable "az_vm_size" {
  type        = string
  description = "Size of the azure vm instance"
}

variable "az_disk_gb" {
  type        = number
  description = "Instance disk size, in gigabytes"
}

variable "az_network_cidr" {
  type        = string
  description = "Network (in CIDR notation) for the azure virtual network"
}

variable "az_subnet_cidr" {
  type        = string
  description = "Network (in CIDR notation) as a sub-network of the azure virtual network"
}

variable "nc_prefix" {
  type        = string
  description = "Friendly prefix string affixed to resource names, like storage buckets and instance(s). Can only consist of lowercase letters and numbers, and must less than 19 characters."
}

variable "ssh_user" {
  type        = string
  description = "User for access to the virtual machine instance, e.g. ubuntu"
}

variable "ssh_key" {
  type        = string
  description = "Public SSH key to access the virtual machine instance"
}

variable "mgmt_cidr" {
  type        = string
  description = "A subnet (in CIDR notation) granted SSH, WebUI, and (if dns_novpn = 1) DNS access to virtual machine instance. Deploying from home? This is your public ip with a /32, e.g. 1.2.3.4/32"
}

resource "random_password" "admin_password" {
  length  = 16
  lower   = true
  special = true
}

resource "random_password" "db_password" {
  length  = 16
  lower   = true
  special = true
}

resource "random_password" "oo_password" {
  length  = 16
  lower   = true
  special = true
}

variable "project_url" {
  type        = string
  description = "URL of the git project"
}

variable "docker_network" {
  type        = string
  description = "docker network ip"
}

variable "docker_gw" {
  type        = string
  description = "docker network gateway ip"
}

variable "docker_nextcloud" {
  type        = string
  description = "nextcloud container ip"
}

variable "docker_db" {
  type        = string
  description = "db container ip"
}

variable "docker_webproxy" {
  type        = string
  description = "https web proxy container ip"
}

variable "docker_storagegw" {
  type        = string
  description = "minio storage gateway container ip"
}

variable "docker_onlyoffice" {
  type        = string
  description = "onlyoffice container ip"
}

variable "docker_duckdnsupdater" {
  type        = string
  description = "duckdns dynamic dns update container ip"
}

variable "project_directory" {
  type        = string
  description = "Location to install/run project"
  default     = "/opt"
}

variable "web_port" {
  type        = string
  description = "Port to run web proxy"
  default     = "443"
}

variable "oo_port" {
  type        = string
  description = "Port to run onlyoffice"
}

variable "enable_duckdns" {
  type = number
}

variable "duckdns_domain" {
  type = string
}

variable "terraform_resource_group_name" {
  type = string
}

variable "terraform_key_vault_name" {
  type = string
}

variable "letsencrypt_email" {
  type = string
}
