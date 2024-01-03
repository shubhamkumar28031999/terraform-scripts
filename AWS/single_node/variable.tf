variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-2"
}

# variable "ubuntu-ami" {
#   description = "Ubuntu 22.04  AMI image"
#   default     = "ami-05a7dfe63c41c160f" // Ubuntu ARM64 Image
# }


variable "ubuntu-ami" {
  description = "Ubuntu 22.04  AMI image"
  default     = "ami-02f3416038bdb17fb" // Ubuntu AMD Image
}

variable "jump-server-IP-Range" {
  default = "0.0.0.0/0"
}

// Bastion Server Credentials 

variable "lakeside-instance-type" {
  description = "Instance Type of bastion/Jump server"
  default     = "c6i.2xlarge"
}

variable "lakeside-disk-size" {
  description = "Root disk size of bastion/Jump server"
  default     = 60
}

// loccust

variable "ubuntu-ami-locust" {
  description = "Ubuntu 22.04  AMI image"
  default     = "ami-05a7dfe63c41c160f" // Ubuntu ARM64 Image
}


variable "locust-instance-type" {
  description = "Instance Type of bastion/Jump server"
  default     = "c7g.16xlarge"
}

variable "locust-disk-size" {
  description = "Root disk size of bastion/Jump server"
  default     = 8
}

