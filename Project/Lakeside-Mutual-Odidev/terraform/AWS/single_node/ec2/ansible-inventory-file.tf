# Generate inventory file
resource "local_file" "inventory" {
    depends_on=[aws_instance.lakeside-ec2,aws_instance.Locust-ec2]
    filename = "./../../../ansible/single_node/hosts"
    content = <<EOF
[lakeside]
${aws_instance.lakeside-ec2.private_ip}
[locust]
${aws_instance.Locust-ec2.private_ip}

[bastion_host]
${aws_instance.BASTION.public_ip}

[lakeside:vars]
ansible_connection=ssh
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ubuntu@${aws_instance.BASTION.public_ip} -W %h:%p"'

[locust:vars]
ansible_connection=ssh
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh ubuntu@${aws_instance.BASTION.public_ip} -W %h:%p"'


[all:vars]
ansible_connection=ssh
ansible_user=ubuntu
EOF       
}
