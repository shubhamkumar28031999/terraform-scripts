output "lakeside-master-private-ip" {
  value = aws_instance.lakeside-master-ec2.private_ip
}

output "locust-private-ip" {
  value = aws_instance.Locust-ec2.private_ip
}

output "bastionhost-public-ip" {
  value = aws_instance.BASTION.public_ip
}

output "lakeside-nodes-private_ip" {
  value = [aws_instance.lakeside-node-ec2.*.private_ip,
          aws_instance.lakeside-node-ec2.*.tags.Name]
}
