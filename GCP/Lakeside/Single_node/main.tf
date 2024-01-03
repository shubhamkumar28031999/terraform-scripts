provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
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


resource "google_compute_instance" "ubuntu-beaver" {
  project                   = var.project
  name                      = "ubuntu-beaver"
  machine_type              = "t2a-standard-1"
  zone                      = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts-arm64"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_snapshot" "ubuntu-beaver" {
  project     = var.project
  name        = "ubuntu-beaver-2018-10-3"
  source_disk = google_compute_instance.ubuntu-beaver.name
  zone        = var.zone
}

resource "google_compute_disk" "striped-horse" {
  project  = var.project
  name     = "striped-horse"
  type     = "pd-ssd"
  zone     = var.zone
  size     = 50
  snapshot = google_compute_snapshot.ubuntu-beaver.name
}


resource "google_compute_instance" "vm-lakeside" {
  name         = "vm-lakeside"
  machine_type = "t2a-standard-2"
  project = var.project
  boot_disk {
    source = google_compute_disk.striped-horse.name
  }
#  service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]
#   }

  metadata = {
    ssh-keys = "${var.ssh-user}:${tls_private_key.ssh.public_key_openssh}"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  tags = ["http-server"]

}



# resource "google_compute_instance" "vm-locust" {
#   name         = "vm-locust"
#   machine_type = "c3-highcpu-22"

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2004-lts"
#     }
#   }
# #  service_account {
# #     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
# #     email  = google_service_account.default.email
# #     scopes = ["cloud-platform"]
# #   }

#   metadata = {
#     ssh-keys = "${var.ssh-user}:${tls_private_key.ssh.public_key_openssh}"
#   }

#   network_interface {
#     network = "default"
#     access_config {
#       // Ephemeral public IP
#     }
#   }
#   tags = ["http-server"]

# }

# resource "google_compute_firewall" "http-server" {
#   name    = "default-allow-http-terraform"
#   network = "default"

#   allow {
#     protocol = "all"
#   }

#   // Allow traffic from everywhere to instances with an http-server tag
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["http-server"]
# }



output "lakeside-ip" {
  value = google_compute_instance.vm-lakeside.network_interface[0].access_config[0].nat_ip
}
# output "locust-ip" {
#   value = google_compute_instance.vm-locust.network_interface[0].access_config[0].nat_ip
# }