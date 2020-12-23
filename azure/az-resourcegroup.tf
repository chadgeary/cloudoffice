resource "azurerm_resource_group" "nc-resourcegroup" {
  name                    = "${var.nc_prefix}-resourcegroup"
  location                = var.az_region
}
