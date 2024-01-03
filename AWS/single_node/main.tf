// Instance config

resource "aws_instance" "ec2_instance_lakeside" {
  ami                    = var.ubuntu-ami
  instance_type          = var.lakeside-instance-type
  vpc_security_group_ids = [aws_security_group.instance_SG.id]
  key_name               = "odidev"

  root_block_device {
    volume_size           = var.lakeside-disk-size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "subham_instance_${var.lakeside-instance-type}"
  }
}


resource "aws_instance" "ec2_instance_locust" {
  ami                    = var.ubuntu-ami-locust
  instance_type          = var.locust-instance-type
  vpc_security_group_ids = [aws_security_group.instance_SG.id]
  key_name               = "odidev"

  root_block_device {
    volume_size           = var.locust-disk-size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "subham_instance_${var.locust-instance-type}"
  }
}
