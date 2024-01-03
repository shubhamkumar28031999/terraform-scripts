resource "local_file" "locust_environment_variable" {
  depends_on = [azurerm_network_interface.lakeside_nic]
  filename   = "./../../../load_test/environmentVariable.py"
  content    = <<EOF
host = "${azurerm_network_interface.lakeside_nic.private_ip_address}"
user = 1000
EOF       
}
