output "bastionhost-Public-IP" {
  description = "Bastion host instance public IP"
  value       = module.ec2.bastionhost-public-ip
}

output "Lakeside-Private-IP" {
  description = "lakeside mutual instance private IP"
  value       = module.ec2.lakeside-master-private-ip
}

output "Locust-Private-IP" {
  description = "Locust instance private IP"
  value       = module.ec2.locust-private-ip
}

output "lakeside-node-private_ip" {
  description = "Private IP of all the lakeside nodes"
  value       = module.ec2.lakeside-nodes-private_ip
}
