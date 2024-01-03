# Create a resource group if it doesn’t exist.
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_prefix}-rg"
  location = var.location

}

# Create virtual network with public and private subnets.
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

}

# Create public subnet for hosting bastion/public VMs.
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.resource_prefix}-pblc-sn001"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}


# Create private subnet for hosting lakeside and locust VMs.
resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.resource_prefix}-prvt-sn001"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

}
