# Generate inventory file
resource "local_file" "inventory" {
  depends_on = [azurerm_network_interface.bastion_nic, azurerm_network_interface.lakeside_nic, azurerm_network_interface.locust_nic]
  filename   = "./../../../ansible/single_node/hosts"
  content    = <<EOF
[lakeside]
${azurerm_network_interface.lakeside_nic.private_ip_address}
[locust]
${azurerm_network_interface.locust_nic.private_ip_address}

[bastion_host]
${azurerm_linux_virtual_machine.bastion_vm.public_ip_address}

[lakeside:vars]
ansible_connection=ssh
ansible_user=${var.username}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ${var.username}@${azurerm_linux_virtual_machine.bastion_vm.public_ip_address} -W %h:%p"'

[locust:vars]
ansible_connection=ssh
ansible_user=${var.username}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ${var.username}@${azurerm_linux_virtual_machine.bastion_vm.public_ip_address} -W %h:%p"'


[all:vars]
ansible_connection=ssh
ansible_user=${var.username}
EOF       
}
