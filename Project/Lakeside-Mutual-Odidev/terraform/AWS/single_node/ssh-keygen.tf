resource "tls_private_key" "task1_q_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "task-key" {
  key_name   = "task-key-Lakeside"
  public_key = tls_private_key.task1_q_key.public_key_openssh
}

resource "local_file" "public_key" {
  depends_on = [
    tls_private_key.task1_q_key,
  ]
  filename        = pathexpand("~/.ssh/id_rsa.pub")
  content         = tls_private_key.task1_q_key.public_key_openssh
  file_permission = "400"
}

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.task1_q_key,
  ]
  filename        = pathexpand("~/.ssh/id_rsa")
  content         = tls_private_key.task1_q_key.private_key_openssh
  file_permission = "400"
}
