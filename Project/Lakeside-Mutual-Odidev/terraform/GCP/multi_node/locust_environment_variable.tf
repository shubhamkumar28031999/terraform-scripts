resource "local_file" "locust_environment_variable" {
  depends_on = [google_compute_instance.lakeside]
  filename   = "./../../../load_test/environmentVariable.py"
  content    = <<EOF
host = "${google_compute_instance.lakeside-node[0].network_interface[0].network_ip}"
user = 1000
EOF       
}
