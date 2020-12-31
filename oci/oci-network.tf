resource "oci_core_vcn" "nc-vcn" {
  compartment_id               = oci_identity_compartment.nc-compartment.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.nc_prefix}-network"
  dns_label                    = var.nc_prefix
}

resource "oci_core_internet_gateway" "nc-internet-gateway" {
  compartment_id               = oci_identity_compartment.nc-compartment.id
  vcn_id                       = oci_core_vcn.nc-vcn.id
  display_name                 = "${var.nc_prefix}-internet-gateway"
  enabled                      = "true"
}

resource "oci_core_subnet" "nc-subnet" {
  compartment_id               = oci_identity_compartment.nc-compartment.id
  vcn_id                       = oci_core_vcn.nc-vcn.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.nc_prefix}-subnet"
}

resource "oci_core_default_route_table" "nc-route-table" {
  manage_default_resource_id   = oci_core_vcn.nc-vcn.default_route_table_id
  route_rules {
    network_entity_id            = oci_core_internet_gateway.nc-internet-gateway.id
    destination                  = "0.0.0.0/0"
    destination_type             = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "nc-route-table-attach" {
  subnet_id                    = oci_core_subnet.nc-subnet.id
  route_table_id               = oci_core_vcn.nc-vcn.default_route_table_id
}

resource "oci_core_network_security_group" "nc-network-security-group" {
  compartment_id               = oci_identity_compartment.nc-compartment.id
  vcn_id                       = oci_core_vcn.nc-vcn.id
  display_name                 = "${var.nc_prefix}-network-security-group"
}

resource "oci_core_default_security_list" "nc-security-list" {
  manage_default_resource_id   = oci_core_vcn.nc-vcn.default_security_list_id
  display_name                 = "${var.nc_prefix}-security"
  egress_security_rules {
    protocol                     = "all"
    destination                  = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "22"
      min                          = "22"
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = "0.0.0.0/0"
    tcp_options {
      max                          = var.web_port
      min                          = var.web_port
    }
  }
}
