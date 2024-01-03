terraform {
  required_version = ">=0.12"

}

provider "azurerm" {
  features {}
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Public IPs for lakeside
resource "azurerm_public_ip" "lakeside_master_pubic_IP" {
  name                = "myPublicIP_lakeside_master"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Public IPs for lakeside
resource "azurerm_public_ip" "lakeside_pubic_IP" {
  name                = "myPublicIP_lakeside_${count.index + 1}"
  count               = var.lakeside_nodes
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Public IPs for locust
resource "azurerm_public_ip" "locust_pubic_IP" {
  name                = "myPublicIP_locust"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-internet-all"
    priority                   = 1200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

}

# Create network interface for lakeside
resource "azurerm_network_interface" "lakeside_master_nic" {
  name                = "lakeside_master_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration_lakeside_master"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lakeside_master_pubic_IP.id
  }
}

# Create network interface for lakeside
resource "azurerm_network_interface" "lakeside_nic" {
  name                = "lakeside_nic_${count.index + 1}"
  count               = var.lakeside_nodes
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration_lakeside"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.lakeside_pubic_IP.*.id, count.index)
  }
}
# Create network interface for locust
resource "azurerm_network_interface" "locust_nic" {
  name                = "locust_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration_locust"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.locust_pubic_IP.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example_lakeside_master" {
  network_interface_id      = azurerm_network_interface.lakeside_master_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example_lakeside" {
  count                 = var.lakeside_nodes
  network_interface_id      = element(azurerm_network_interface.lakeside_nic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example_locust" {
  network_interface_id      = azurerm_network_interface.locust_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create Lakeside machine

resource "azurerm_linux_virtual_machine" "lakeside_master_node" {
  name                  = "Lakeside_master_instance"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = azurerm_network_interface.lakeside_master_nic.*.id
  size                  = var.lakeside_master_instance_type

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-arm64"
    version   = "20.04.202209200"
  }

  computer_name                   = var.lakeside_master_computer_name
  admin_username                  = var.username
  admin_password = var.password
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}


resource "azurerm_linux_virtual_machine" "lakeside_node" {
  name                  = "Lakeside_instance_${count.index + 1}"
  count                 = var.lakeside_nodes
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [element(azurerm_network_interface.lakeside_nic.*.id, count.index)]
  size                  = var.lakeside_node_instance_type

  os_disk {
    name                 = "myOsDisk-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-arm64"
    version   = "20.04.202209200"
  }

  computer_name                   = "${var.lakeside_worker_node_computer_name}-${count.index + 1}"
  admin_username                  = var.username
  admin_password = var.password
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}


# Create Lakeside machine
resource "azurerm_linux_virtual_machine" "locust_node" {
  name                  = "Locust_instance"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = azurerm_network_interface.locust_nic.*.id
  size                  = var.locust_node_instance_type

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  computer_name                   = var.locust_computer_name
  admin_username                  = var.username
  admin_password = var.password
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}