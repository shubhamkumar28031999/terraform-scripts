[lakesideMaster]
${lakeside_master_private_ip}

[lakesideNodes]
%{ for ip in lakeside_node_private_ip ~}
${ip}
%{ endfor ~}

[locust]
${locust_private_ip}

[bastion_host]
${bastion_host_public_ip}

[lakesideMaster:vars]
ansible_connection=ssh
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ubuntu@${bastion_host_public_ip} -W %h:%p"'

[lakesideNodes:vars]
ansible_connection=ssh
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ubuntu@${bastion_host_public_ip} -W %h:%p"'


[locust:vars]
ansible_connection=ssh
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ubuntu@${bastion_host_public_ip} -W %h:%p"'


[all:vars]
ansible_connection=ssh
ansible_user=ubuntu
