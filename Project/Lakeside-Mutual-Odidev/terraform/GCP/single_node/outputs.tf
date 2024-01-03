output "public_ip_bastion_host" {
  description = "The public IP of the bastion host."
  value       = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip
}

output "Lakeside_ip_instance" {
  description = "Private IP of the Lakeside private instance"
  value       = google_compute_instance.lakeside.network_interface[0].network_ip
}

output "Locust_ip_instance" {
  description = "Private IP of the Lakeside private instance"
  value       = google_compute_instance.locust.network_interface[0].network_ip
}
