# Generate inventory file
resource "local_file" "inventory" {
    depends_on=[azurerm_linux_virtual_machine.lakeside_master_node,azurerm_linux_virtual_machine.lakeside_node,azurerm_linux_virtual_machine.locust_node]
    content = templatefile("./hosts_template.tpl",
    {
      username = var.username
      password = var.password
      lakeside_master_public_ip = azurerm_linux_virtual_machine.lakeside_master_node.public_ip_address
      lakeside_node_public_ip = azurerm_linux_virtual_machine.lakeside_node.*.public_ip_address
      locust_public_ip =azurerm_linux_virtual_machine.locust_node.public_ip_address
    }
    )
    filename = "./hosts"
}