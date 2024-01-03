output "bastionhost-Public-IP" {
  description = "Bastion host instance public IP"
  value       = module.ec2.bastionhost-public-ip
}

output "Lakeside-Private-IP" {
  description = "lakeside mutual instance private IP"
  value       = module.ec2.lakeside-private-ip
}

output "Locust-Private-IP" {
  description = "Locust instance private IP"
  value       = module.ec2.locust-private-ip
}
