# Generate random text for a unique storage account name.
resource "random_id" "random_id" {
  keepers = {

    # Generate a new ID only when a new resource group is defined.
    resource_group = "${azurerm_resource_group.resource_group.name}"
  }

  byte_length = 8
}



# Create storage account for boot diagnostics.
resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# Create bastion host VM.
resource "azurerm_linux_virtual_machine" "bastion_vm" {
  name                  = "${var.resource_prefix}-bstn-vm001"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = ["${azurerm_network_interface.bastion_nic.id}"]
  size                  = var.bastion_host_VM_size

  os_disk {
    name                 = "${var.resource_prefix}-bstn-dsk001"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-arm64"
    version   = "20.04.202209200"
  }

  computer_name                   = "${var.resource_prefix}-bstn-vm001"
  admin_username                  = var.username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.lakeside-ssh-key.public_key_openssh #The magic here
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

}

# Create Lakeside VM.
resource "azurerm_linux_virtual_machine" "lakeside_vm" {
  name                  = "${var.resource_prefix}-lakeside-vm001"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = ["${azurerm_network_interface.lakeside_nic.id}"]
  size                  = var.lakeside_VM_size

  os_disk {
    name                 = "${var.resource_prefix}-lakeside-dsk001"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-arm64"
    version   = "20.04.202209200"
  }

  computer_name                   = "${var.resource_prefix}-lakeside-vm001"
  admin_username                  = var.username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.lakeside-ssh-key.public_key_openssh #The magic here
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

}

# Create Locust VM.
resource "azurerm_linux_virtual_machine" "locust_vm" {
  name                  = "${var.resource_prefix}-locust-vm001"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = ["${azurerm_network_interface.locust_nic.id}"]
  size                  = var.locust_VM_size

  os_disk {
    name                 = "${var.resource_prefix}-locust-dsk001"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-arm64"
    version   = "20.04.202209200"
  }

  computer_name                   = "${var.resource_prefix}-locust-vm001"
  admin_username                  = var.username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.lakeside-ssh-key.public_key_openssh #The magic here
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

}
