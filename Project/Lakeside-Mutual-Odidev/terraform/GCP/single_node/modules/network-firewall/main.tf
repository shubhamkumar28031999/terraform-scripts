data "google_compute_subnetwork" "public_subnetwork" {
  self_link = var.public_subnetwork
}

data "google_compute_subnetwork" "private_subnetwork" {
  self_link = var.private_subnetwork
}

# public - allow ingress from anywhere
resource "google_compute_firewall" "public_allow_all_inbound" {
  name = "bastion-public-allow-ingress"
  project = var.project
  network = var.network
  target_tags   = ["public"]

  source_ranges = ["0.0.0.0/0"]
  priority = "1000"
  allow {
    protocol = "icmp"
  }
  allow {
   protocol = "all"
  }
}

# public - allow ingress from specific sources
resource "google_compute_firewall" "public_restricted_allow_inbound" {
  count = length(var.allowed_public_restricted_subnetworks) > 0 ? 1 : 0
  name = "bastion-public-restricted-allow-ingress"
  project = var.project
  network = var.network
  target_tags   = ["public-restricted"]
  source_ranges = var.allowed_public_restricted_subnetworks
  priority = "1000"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "all"
  }
}

# private - allow ingress from within this network
resource "google_compute_firewall" "private_allow_all_network_inbound" {
  name = "bastion-private-allow-ingress"
  project = var.project
  network = var.network
  target_tags = ["private"]
  source_ranges = [
    data.google_compute_subnetwork.public_subnetwork.ip_cidr_range,
    data.google_compute_subnetwork.public_subnetwork.secondary_ip_range[0].ip_cidr_range,
    data.google_compute_subnetwork.public_subnetwork.secondary_ip_range[1].ip_cidr_range,
    data.google_compute_subnetwork.private_subnetwork.ip_cidr_range,
    data.google_compute_subnetwork.private_subnetwork.secondary_ip_range[0].ip_cidr_range,
  ]
  priority = "1000"
  allow {
    protocol = "icmp"
  }
  allow {
    ports    = ["22","80","8080","8090","61613","61616","8100","8110","3000","3010","3020","50051","8761","9000"]
    protocol = "tcp"
  }
}

# private-persistence - allow ingress from `private` and `private-persistence` instances in this network
resource "google_compute_firewall" "private_allow_restricted_network_inbound" {
  name = "bastion-allow-restricted-inbound"
  project = var.project
  network = var.network
  target_tags = ["private-persistence"]
  source_tags = ["private", "private-persistence"]
  priority = "1000"
  allow {
    protocol = "icmp"
  }
  allow {
    ports    = ["22","80","8080","8090","61613","61616","8100","8110","3000","3010","3020","50051","8761","9000"]
    protocol = "tcp"
  }
}
