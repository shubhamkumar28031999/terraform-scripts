# Generate inventory file
resource "local_file" "inventory" {
    depends_on=[aws_instance.lakeside-master-ec2,aws_instance.Locust-ec2,aws_instance.lakeside-node-ec2]
    # filename = "./../../ansible/multi_node/hosts"
    content = templatefile("./ec2/templates/hosts.tpl",
    {
      lakeside_master_private_ip = aws_instance.lakeside-master-ec2.private_ip
      lakeside_node_private_ip = aws_instance.lakeside-node-ec2.*.private_ip
      locust_private_ip = aws_instance.Locust-ec2.private_ip
      bastion_host_public_ip = aws_instance.BASTION.public_ip
    }
    )
    filename = "./../../../ansible/multi_node/hosts"
}
