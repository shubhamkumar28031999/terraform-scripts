[lakesideMaster]
${lakeside_master_public_ip}

[lakesideNodes]
%{ for ip in lakeside_node_public_ip ~}
${ip}
%{ endfor ~}

[locust]
${locust_public_ip}

[all:vars]
ansible_connection=ssh
ansible_user=${username}
ansible_ssh_pass=${password}