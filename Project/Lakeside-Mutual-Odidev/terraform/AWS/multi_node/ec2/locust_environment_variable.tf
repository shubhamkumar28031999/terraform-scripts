# Generate locust environment variable file
resource "local_file" "locust_environment_variable" {
    depends_on=[aws_instance.lakeside-master-ec2]
    filename = "./../../../load_test/environmentVariable.py"
    content = <<EOF
host = "${aws_instance.lakeside-master-ec2.private_ip}"
user = 1000
EOF
}

