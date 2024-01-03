# IP addresses of public IP addresses provisioned.
output "bastion_host_public_ip" {
  description = "IP addresses of public IP addresses provisioned."
  value       = azurerm_linux_virtual_machine.bastion_vm.public_ip_address
}

# IP addresses of private IP addresses provisioned.
output "Lakeside_master_private_ip" {
  description = "IP addresses of private IP addresses provisioned."
  value       = azurerm_network_interface.lakeside_nic.private_ip_address
}

output "Lakeside_node_private_ip" {
  description = "IP addresses of private IP addresses provisioned."
  value       = azurerm_network_interface.lakeside_node_nic.*.private_ip_address
}

output "Locust_private_ip" {
  description = "IP addresses of private IP addresses provisioned."
  value       = azurerm_network_interface.locust_nic.private_ip_address
}
