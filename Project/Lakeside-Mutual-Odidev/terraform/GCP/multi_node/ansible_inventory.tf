resource "local_file" "inventory" {
  depends_on = [google_compute_instance.bastion_host, google_compute_instance.lakeside, google_compute_instance.locust, google_compute_instance.lakeside-node]
  content = templatefile("./modules/templates/hosts.tpl",
    {
      lakeside_master_private_ip = google_compute_instance.lakeside.network_interface[0].network_ip
      lakeside_node_private_ip   = google_compute_instance.lakeside-node[*].network_interface[0].network_ip
      locust_private_ip          = google_compute_instance.locust.network_interface[0].network_ip
      bastion_host_public_ip     = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip
      username                   = var.vm_username
    }
  )
  filename = "./../../../ansible/multi_node/hosts"
}
