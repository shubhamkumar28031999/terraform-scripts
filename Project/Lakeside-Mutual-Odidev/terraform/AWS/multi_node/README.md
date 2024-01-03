# Multi-node terraform configurations on AWS

This setup uses a jump server (also known as a bastion host) to communicate with Lakeside and Locust instances that are deployed under the private subnet. A jump server setup creates a security barrier between networks, preventing outsiders from maliciously gaining access to sensitive company data. 

Before using the terraform commands we need to modified some files first before deploying EC2 instances. First we need to provide AWS region in ```./variable.tf``` file.

```
variable "region" {
    description = "The AWS region to create resources in."
    default = "<AWS Region>"
}
```
To deploy the Lakeside over multiple instances, by default we are using the c7g.2xlarge instance with 30 GB of space for master and node instances, while to deploy the Locust instance in the private subnet, we are using the c7g.16xlarge instance. In order to connect to these instances, we are using the jump server which uses a t4g.medium instance with 8 GB of space by default. The above default values can be configured in ```ec2/variable.tf``` files. 

```
variable "ubuntu-ami" {
    description = "Ubuntu 22.04  AMI image"
    default = "ami-05a7dfe63c41c160f"    // Ubuntu ARM64 Image
}

// Bastion Server Credentials 

variable "bastionhost-instance-type" {
    description = "Instance Type of bastion/Jump server"
    default = "t4g.medium"
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
    default = "c7g.2xlarge"
}

variable "lakeside-disk-size" {
    description = "Root disk size of Lakeside server"
    default = 30
}

// Locust Server Credentials 

variable "locust-instance-type" {
    description = "Instance Type of Locust server"
    default = "c7g.16xlarge"
}

variable "locust-disk-size" {
    description = "Root disk size of Locust server"
    default = 8
}


// Lakeside node instance Credentials

variable "lakeside-node-count" {
    description = "Make true to deploy the traefik proxy instance"
  default = 11
}

variable "lakeside-node-instance-type" {
    description = "Lakeside Node instance Type "
    default = "c7g.2xlarge"
}

variable "lakeside-node-disk-size" {
    description = "Root disk size of Locust server"
    default = 30
}
```

## Terraform commands

To deploy the instances, we need to initialize Terraform using the below-mentioned command inside theterraform directory. This command will download all the configuration files which are needed to deploy the instance on AWS
```
# terraform init
```

Now we need to apply our Terraform scripts to create the instances with the configurations which we have mentioned in the Terraform files. To apply the Terraform script use the below-mentioned command: -  

```
# terraform apply
```

**Note: -** This Terraform script is configured in such a way it will auto-generate the inventory file for the Ansible and environmentVariable.py file for load testing. 
