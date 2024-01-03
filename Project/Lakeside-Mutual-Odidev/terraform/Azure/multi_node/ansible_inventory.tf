resource "local_file" "inventory" {
  depends_on = [azurerm_linux_virtual_machine.bastion_vm, azurerm_network_interface.locust_nic, azurerm_network_interface.lakeside_node_nic, azurerm_network_interface.lakeside_nic]
  content = templatefile("./templates/hosts.tpl",
    {
      lakeside_master_private_ip = azurerm_network_interface.lakeside_nic.private_ip_address
      lakeside_node_private_ip   = azurerm_network_interface.lakeside_node_nic.*.private_ip_address
      locust_private_ip          = azurerm_network_interface.locust_nic.private_ip_address
      bastion_host_public_ip     = azurerm_linux_virtual_machine.bastion_vm.public_ip_address
      username                   = var.username
    }
  )
  filename = "./../../../ansible/multi_node/hosts"
}
