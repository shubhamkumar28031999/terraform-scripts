output "ec2_instance_lakeside_IP" {
  value = [aws_instance.ec2_instance_lakeside.*.public_ip]
}

output "ec2_instance_locust_IP" {
  value = aws_instance.ec2_instance_locust.public_ip
}