variable "project" {
  description = "The name of the GCP Project where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The region in which the VPC netowrk's subnetwork will be created."
  type        = string
}

variable "zone" {
  description = "The zone in which the bastion host VM instance will be launched. Must be within the region."
  type        = string
}

variable "static_ip" {
  description = "A static IP address to attach to the instance. The default will allocate an ephemeral IP"
  type        = string
  default     = null
}


variable "vm_username" {
  description = "instance username"
  type        = string
}

variable "bastion_host_machine_type" {
  description = "bastion host machine type"
  type        = string
}

variable "lakeside_master_node_machine_type" {
  description = "lakeside master node machine type"
  type        = string
}

variable "lakeside_worker_node_machine_type" {
  description = "lakeside worker machine type"
  type        = string
}

variable "lakesideNodeCount" {
  description = "Lakeside nodes"
}

variable "locust_machine_type" {
  description = "locust machine type"
  type        = string
}

