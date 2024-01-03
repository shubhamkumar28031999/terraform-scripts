variable "project-name" {
  type    = string
  default = "gke-cluster-375814"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "ssh-user" {
  type    = string
  default = "odidev_puresoftware_com"
}

// lakeside 
variable "lakeside-os-image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts-arm64"
}

variable "lakeside-machine_type" {
  type    = string
  default = "t2a-standard-2"
}

// worker node 

variable "lakeside-worker-node-count" {

  default = 10
}

// locust

variable "locust-os-image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "locust-machine_type" {
  type    = string
  default = "c3-highcpu-22"
}