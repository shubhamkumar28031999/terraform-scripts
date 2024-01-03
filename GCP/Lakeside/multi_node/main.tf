provider "google" {
  project = var.project-name
  region  = var.region
  zone    = var.zone
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "C:/Users/shubham.kumar/.ssh/google_compute_engine"
  file_permission = "700"
}


resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "all"
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}



resource "google_compute_instance" "vm-lakeside-master" {
  name         = "master"
  machine_type = var.lakeside-machine_type

  boot_disk {
    initialize_params {
      image = var.lakeside-os-image
    }
  }

  metadata = {
    ssh-keys = "${var.ssh-user}:${tls_private_key.ssh.public_key_openssh}"
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  tags = ["http-server"]

}

resource "google_compute_instance" "vm-lakeside-worker" {
  name         = "node-${count.index + 1}"
  count        = var.lakeside-worker-node-count
  machine_type = var.lakeside-machine_type

  boot_disk {
    initialize_params {
      image = var.lakeside-os-image
    }
  }

  metadata = {
    ssh-keys = "${var.ssh-user}:${tls_private_key.ssh.public_key_openssh}"
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  tags = ["http-server"]

}


resource "google_compute_instance" "vm-locust" {
  name         = "vm-locust"
  machine_type = var.locust-machine_type

  boot_disk {
    initialize_params {
      image = var.locust-os-image
    }
  }

  metadata = {
    ssh-keys = "${var.ssh-user}:${tls_private_key.ssh.public_key_openssh}"
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  tags = ["http-server"]

}


output "lakeside-master-ip" {
  value = google_compute_instance.vm-lakeside-master.network_interface[0].access_config[0].nat_ip
}
output "lakeside-worker-ip" {
  value = google_compute_instance.vm-lakeside-worker[*].network_interface[0].access_config[0].nat_ip
}
output "locust-ip" {
  value = google_compute_instance.vm-locust.network_interface[0].access_config[0].nat_ip
}