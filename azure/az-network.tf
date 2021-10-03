resource "azurerm_virtual_network" "nc-network" {
  name                = "${var.nc_prefix}-network"
  location            = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name = azurerm_resource_group.nc-resourcegroup.name
  address_space       = [var.az_network_cidr]
}

resource "azurerm_subnet" "nc-subnet" {
  name                 = "${var.nc_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.nc-resourcegroup.name
  virtual_network_name = azurerm_virtual_network.nc-network.name
  address_prefixes     = [var.az_subnet_cidr]
}

resource "azurerm_public_ip" "nc-public-ip" {
  name                = "${var.nc_prefix}-public-ip"
  location            = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name = azurerm_resource_group.nc-resourcegroup.name
  sku                 = "Basic"
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nc-net-sec" {
  name                = "${var.nc_prefix}-net-sec"
  location            = azurerm_resource_group.nc-resourcegroup.location
  resource_group_name = azurerm_resource_group.nc-resourcegroup.name
  security_rule {
    name                        = "${var.nc_prefix}-net-rule-ssh"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"

    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }
  security_rule {
    name                         = "${var.nc_prefix}-net-rule-https"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = var.web_port
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }

  security_rule {
    name                         = "${var.nc_prefix}-net-rule-httpsoo"
    priority                     = 102
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = var.oo_port
    source_address_prefix        = var.mgmt_cidr
    destination_address_prefixes = [var.az_subnet_cidr]
  }

  security_rule {
    name                         = "${var.nc_prefix}-net-rule-selfhttps"
    priority                     = 103
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = var.web_port
    source_address_prefix        = "${azurerm_public_ip.nc-public-ip.ip_address}/32"
    destination_address_prefixes = [var.az_subnet_cidr]
  }

  security_rule {
    name                         = "${var.nc_prefix}-net-rule-selfhttpsoo"
    priority                     = 104
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = var.oo_port
    source_address_prefix        = "${azurerm_public_ip.nc-public-ip.ip_address}/32"
    destination_address_prefixes = [var.az_subnet_cidr]
  }
}

resource "azurerm_subnet_network_security_group_association" "nc-net-sec-assoc" {
  subnet_id                 = azurerm_subnet.nc-subnet.id
  network_security_group_id = azurerm_network_security_group.nc-net-sec.id
}
