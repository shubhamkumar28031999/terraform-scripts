resource "tls_private_key" "lakeside-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "public_key" {
  depends_on = [
    tls_private_key.lakeside-ssh-key,
  ]
  filename        = pathexpand("~/.ssh/id_rsa.pub")
  content         = tls_private_key.lakeside-ssh-key.public_key_openssh
  file_permission = "400"
}

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.lakeside-ssh-key,
  ]
  filename        = pathexpand("~/.ssh/id_rsa")
  content         = tls_private_key.lakeside-ssh-key.private_key_openssh
  file_permission = "400"
}
