resource "random_string" "nc-random" {
  length  = 5
  upper   = false
  special = false
}

variable "aws_region" {
  type = string
}

variable "aws_az" {
  type    = number
  default = 0
}

variable "aws_profile" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "pubnet_cidr" {
  type = string
}

variable "pubnet_instance_ip" {
  type = string
}

variable "mgmt_cidr" {
  type        = string
  description = "Subnet CIDR allowed to access WebUI and SSH, e.g. <home ip address>/32"
}

variable "admin_password" {
  type        = string
  description = "Nextcloud admin and root db password"
}

variable "db_password" {
  type        = string
  description = "application db password"
}

variable "oo_password" {
  type        = string
  description = "application onlyoffice password"
}

variable "bundle_id" {
  type        = string
  description = "The type of lightsail instance to deploy"
}

variable "blueprint_id" {
  type        = string
  description = "The OS of lightsail instance to deploy"
}

variable "ssh_key" {
  type        = string
  description = "A public key for SSH access to instance(s)"
}

variable "name_prefix" {
  type        = string
  description = "A friendly name prefix for the AMI and EC2 instances, e.g. 'ph' or 'dev'"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# region azs
data "aws_availability_zones" "nc-azs" {
  state = "available"
}

# account id
data "aws_caller_identity" "nc-aws-account" {
}

variable "kms_manager" {
  type        = string
  description = "An IAM user for management of KMS key"
}

data "aws_iam_user" "nc-kmsmanager" {
  user_name = var.kms_manager
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
  description = "nextcloud app container ip"
}

variable "docker_webproxy" {
  type        = string
  description = "https web proxy container ip"
}

variable "docker_db" {
  type        = string
  description = "db container ip"
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
  default     = "8443"
}

variable "enable_duckdns" {
  type = number
}

variable "duckdns_domain" {
  type = string
}

variable "duckdns_token" {
  type = string
}

variable "letsencrypt_email" {
  type = string
}
