terraform {
  required_version = ">= 0.12.26"
}

# Create a Management Network for shared services
module "management_network" {
  source  = "./modules/vpc-network"
  project = var.project
  region  = var.region
}

# Add public key to IAM user
data "google_client_openid_userinfo" "me" {}
resource "google_os_login_ssh_public_key" "cache" {
  project = var.project
  user    = data.google_client_openid_userinfo.me.email
  key     = file("~/.ssh/id_rsa.pub")
}

# Ensure IAM user is allowed to use OS Login
resource "google_project_iam_member" "project" {
  project = var.project
  role    = "roles/compute.osAdminLogin"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

# Create an instance with OS Login configured to use as a bastion host
resource "google_compute_instance" "bastion_host" {
  project      = var.project
  name         = "bastion-vm"
  machine_type = var.bastion_host_machine_type
  zone         = var.zone
  tags         = ["public"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts-arm64"
    }
  }
  network_interface {
    subnetwork = module.management_network.public_subnetwork
    // If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
      nat_ip = var.static_ip
    }
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
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

# Create a private instance for Lakeside
resource "google_compute_instance" "lakeside" {
  project                   = var.project
  name                      = "lakeside"
  machine_type              = var.lakeside_machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["private"]
  boot_disk {
    source = google_compute_disk.striped-horse.name
  }
  network_interface {
    subnetwork = module.management_network.private_subnetwork
    access_config {
      // Explicit public IP
      nat_ip = var.static_ip
    }
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
}


# Create a private instance for locust
resource "google_compute_instance" "locust" {
  project                   = var.project
  name                      = "locust"
  machine_type              = var.locust_machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["private"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts-arm64"
    }
  }
  network_interface {
    subnetwork = module.management_network.private_subnetwork
    access_config {
      // Explicit public IP
      nat_ip = var.static_ip
    }

  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}
