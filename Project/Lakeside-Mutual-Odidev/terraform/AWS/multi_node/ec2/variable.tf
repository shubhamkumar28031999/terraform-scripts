variable "ubuntu-ami" {
    description = "Ubuntu 22.04  AMI image"
    default = "ami-05a7dfe63c41c160f"    // Ubuntu ARM64 Image
}

// Bastion Server Credentials 

variable "bastionhost-instance-type" {
    description = "Instance Type of bastion/Jump server"
    default = "t4g.small"
}

variable "bastionhost-disk-size" {
    description = "Root disk size of bastion/Jump server"
    default = 8
}

variable "jump-server-IP-Range" {
  default= "0.0.0.0/0"
}

// Lakeside Server Credentials 

variable "lakeside-instance-type" {
    description = "Instance Type of Lakeside server"
    default = "t4g.large"
}

variable "lakeside-disk-size" {
    description = "Root disk size of Lakeside server"
    default = 40
}

// Locust Server Credentials 

variable "locust-instance-type" {
    description = "Instance Type of Locust server"
    default = "t4g.small"
}

variable "locust-disk-size" {
    description = "Root disk size of Locust server"
    default = 8
}


// Lakeside node instance Credentials

variable "lakeside-node-count" {
    description = "Make true to deploy the traefik proxy instance"
  default = 3
}

variable "lakeside-node-instance-type" {
    description = "Lakeside Node instance Type "
    default = "t4g.small"
}

variable "lakeside-node-disk-size" {
    description = "Root disk size of Locust server"
    default = 8
}
