output "lakeside_master_public_ip_address" {
  value = azurerm_linux_virtual_machine.lakeside_master_node.public_ip_address
}

output "lakeside_public_ip_address" {
  value = azurerm_linux_virtual_machine.lakeside_node.*.public_ip_address
}

output "locust_public_ip_address" {
  value = azurerm_linux_virtual_machine.locust_node.public_ip_address
}