# Create a public IP address for bastion host VM in public subnet.
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.resource_prefix}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"

}

# Create network interface for bastion host VM in public subnet.
resource "azurerm_network_interface" "bastion_nic" {
  name                = "${var.resource_prefix}-bstn-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.resource_prefix}-bstn-nic-cfg"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

}

# Create network interface for lakeside host VM in private subnet.
resource "azurerm_network_interface" "lakeside_nic" {
  name                = "${var.resource_prefix}-lakeside-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.resource_prefix}-lakesdie-nic-cfg"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

# Create network interface for locust host VM in private subnet.
resource "azurerm_network_interface" "locust_nic" {
  name                = "${var.resource_prefix}-locust-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "${var.resource_prefix}-locust-nic-cfg"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}
