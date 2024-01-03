variable "resource_group_location" {
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

// lakeside node instance type 
variable "username" {
  type        = string
  description = " lakeside worker nodes instance types"
}

variable "password" {
  type        = string
  description = " lakeside worker nodes instance types"
}

// lakeside node instance type 
variable "lakeside_master_instance_type" {
  type        = string
  description = " lakeside worker nodes instance types"
}

variable "lakeside_master_computer_name" {
  type        = string
  description = " lakeside worker nodes instance types"
}

// lakeside node instance type 
variable "lakeside_node_instance_type" {
  type        = string
  description = " lakeside worker nodes instance types"
}

variable "lakeside_worker_node_computer_name" {
  type        = string
  description = " lakeside worker nodes instance types"
}

variable "lakeside_nodes" {
  description = "Number of lakeside worker nodes"
}

// Number of Lakeside instances
variable "locust_node_instance_type" {
  description = "locust node instance type"
}

variable "locust_computer_name" {
  type        = string
  description = " lakeside worker nodes instance types"
}